//
//  GameScene.swift
//  Kuggen
//
//  Created by Emil Josefsson on 2019-03-07.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import SpriteKit
import FourInOneCore
import MultipeerConnectivity
import GameplayKit

// Protocol for game over
protocol GameSceneDelegate {
    func gameScene(_ gameScene:GameScene, didEndLevelWithSuccess result:Bool)
    
}

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let robot   : UInt32 = 0b1
    static let cogwheel: UInt32 = 0b10
    static let key: UInt32 = 0b11
    static let lock: UInt32 = 0b111
}

private let handleOne = Handle.edgeCircle
private let handleTwo = Handle.edgeSquare
private let handleThree = Handle.edgeTrapezoid
private let handleFour = Handle.edgeTriangle




class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Game manager, create and manage request objects
    var gameManager : KuggenSessionManager!
    var gameScenDelegate : GameSceneDelegate?
    private var latestPoint = CGPoint()
    var limit : CGFloat = 6.0


    
    // Create robot arms and cogwheel properties
    private let robotOne = Robot(matchingHandle: handleOne, devicePosition: .one, textureName: "fingerprint")
    private let robotTwo = Robot(matchingHandle: handleTwo, devicePosition: .two, textureName: "fingerprint")
    private let robotThree = Robot(matchingHandle: handleThree, devicePosition: .three, textureName: "fingerprint")
    private let robotFour = Robot(matchingHandle: handleFour, devicePosition: .four, textureName: "fingerprint")
  
    /*private let cogwheelOne = Cogwheel(handle: handleOne, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black)
    private let cogwheelTwo = Cogwheel(handle: handleTwo, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black)
    private let cogwheelThree = Cogwheel(handle: handleThree, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black)
    private let cogwheelFour = Cogwheel(handle: handleFour, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black)*/
    
    private let level: Level
    private let cogwheelOne: Cogwheel
    private let cogwheelTwo: Cogwheel
    private let cogwheelThree: Cogwheel
    private let cogwheelFour: Cogwheel
    
    // Init
    required init?(coder aDecoder: NSCoder) {
        level = LevelReader.createLevel(nameOfLevel: "level1")
        cogwheelOne = level.cogwheels[0]
        cogwheelTwo = level.cogwheels[1]
        cogwheelThree = level.cogwheels[2]
        cogwheelFour = level.cogwheels[3]
        super.init(coder: aDecoder)
    }
    
    // Initalize new scene object
    convenience override init(size: CGSize) {
        self.init(size: size, levelNo: 1)
    }
    
    //Creates a GameScene for a specific level
    init(size: CGSize, levelNo: Int){
        //level = LevelReader.createLevel(nameOfLevel: "level \(levelNo)")
        level = LevelReader.createLevel(nameOfLevel: "level1")
        cogwheelOne = level.cogwheels[0]
        cogwheelTwo = level.cogwheels[1]
        cogwheelThree = level.cogwheels[2]
        cogwheelFour = level.cogwheels[3]
        super.init(size: size)
    }
    
    // When scene is presented by view
    override func didMove(to view: SKView) {
        // setup the scene
        self.layoutScene()
    }
    
    /*override func sceneDidLoad() {
   
     }*/
    
    private func initPhysics(){
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        //robot one
        robotOne.physicsBody = SKPhysicsBody(texture: robotOne.texture!, size: robotOne.texture!.size())
        robotOne.physicsBody?.isDynamic = true
        robotOne.physicsBody?.categoryBitMask = PhysicsCategory.robot
        robotOne.physicsBody?.contactTestBitMask = PhysicsCategory.cogwheel
        robotOne.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        
        //robotOne.anchorPoint = CGPoint(x: 0, y: 0)
        //robotTwo.anchorPoint = CGPoint(x: 0.5, y: 0.25)
        //robotThree.anchorPoint = CGPoint(x: 0, y: 0)
        //robotFour.anchorPoint = CGPoint(x: 0, y: 0)
        
        robotTwo.physicsBody = SKPhysicsBody(texture: robotTwo.texture!, size: robotTwo.texture!.size())
        robotTwo.physicsBody?.isDynamic = true
        robotTwo.physicsBody?.categoryBitMask = PhysicsCategory.robot
        robotTwo.physicsBody?.contactTestBitMask = PhysicsCategory.cogwheel
        robotTwo.physicsBody?.collisionBitMask = PhysicsCategory.none

        robotThree.physicsBody = SKPhysicsBody(texture: robotThree.texture!, size: robotThree.texture!.size())
        robotThree.physicsBody?.isDynamic = true
        robotThree.physicsBody?.categoryBitMask = PhysicsCategory.robot
        robotThree.physicsBody?.contactTestBitMask = PhysicsCategory.cogwheel
        robotThree.physicsBody?.collisionBitMask = PhysicsCategory.none

        robotFour.physicsBody = SKPhysicsBody(texture: robotFour.texture!, size: robotFour.texture!.size())
        robotFour.physicsBody?.isDynamic = true
        robotFour.physicsBody?.categoryBitMask = PhysicsCategory.robot
        robotFour.physicsBody?.contactTestBitMask = PhysicsCategory.cogwheel
        robotFour.physicsBody?.collisionBitMask = PhysicsCategory.none

        cogwheelOne.physicsBody = SKPhysicsBody(texture: cogwheelOne.texture!, size: cogwheelOne.texture!.size())
        cogwheelOne.physicsBody?.isDynamic = true
        cogwheelOne.physicsBody?.categoryBitMask = PhysicsCategory.cogwheel
        cogwheelOne.physicsBody?.contactTestBitMask = PhysicsCategory.cogwheel
        cogwheelOne.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        //TODO: add physics for three more cogwheel

    }
    
    // Setup the scene, add scenes and behaviours
    func layoutScene() {
        // Test
        print("Scene Setup")
        // data is sent once and is not sent again if a transmission error occurs
        gameManager.sendDataMode = .unreliable
        gameManager.delegate = self as FourInOneSessionManagerDelegate
        
        // set the background color
        self.backgroundColor = SKColor.gray
        
        // Shadows
        let lightNode = SKLightNode()
        //lightNode.position = CGPoint(x: (self.size.width)/2, y: (self.size.width)/2)
        lightNode.position = CGPoint(x: (self.size.width)/2, y: (self.size.width)/2)
        lightNode.categoryBitMask = 1
        lightNode.falloff = CGFloat(0.01)
        lightNode.lightColor = UIColor.white
        lightNode.shadowColor = UIColor.gray
        self.addChild(lightNode)
        
        // Physics - Setup physics here
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        // Game manager, set up the robot and cogwheel properties
        self.gameManager.robotOne = robotOne
        self.gameManager.robotTwo = robotTwo
        self.gameManager.cogwheelOne = cogwheelOne
        self.gameManager.cogwheelTwo = cogwheelTwo
        if(gameManager.mode == .fourplayer){
            self.gameManager.robotThree = robotThree
            self.gameManager.robotFour = robotFour
            self.gameManager.cogwheelThree = cogwheelThree
            self.gameManager.cogwheelFour = cogwheelFour
        }
        
        // add nodes to scene
        if gameManager.mode == .twoplayer
        {
            self.addChild(robotOne)
            self.addChild(robotTwo)
            robotOne.name = "robot_1"
            robotTwo.name = "robot_2"
            self.addChild(cogwheelOne)
            self.addChild(cogwheelTwo)
            cogwheelOne.name = "cog_1"
            cogwheelTwo.name = "cog_2"
            
        

            robotOne.lightingBitMask = 1
            robotOne.shadowedBitMask = 0b0001
            
            robotTwo.lightingBitMask = 1
            robotTwo.shadowedBitMask = 0b0001
            
            cogwheelOne.lightingBitMask = 1
            cogwheelOne.shadowedBitMask = 0b0001
            
            cogwheelTwo.lightingBitMask = 1
            cogwheelTwo.shadowedBitMask = 0b0001
            
            self.addChild(robotOne.getArm())
            self.addChild(robotTwo.getArm())
            //adding the arms to the screen
            /*for arm in robotOne.getArms(){
                self.addChild(arm)
            }
            for arm in robotTwo.getArms(){
                self.addChild(arm)
            }*/

        }
        
        else if gameManager.mode == .fourplayer{
            self.addChild(robotOne)
            self.addChild(robotTwo)
            self.addChild(robotThree)
            self.addChild(robotFour)
            robotOne.name = "robot_1"
            robotTwo.name = "robot_2"
            robotThree.name = "robot_3"
            robotFour.name = "robot_4"
            self.addChild(cogwheelOne)
            self.addChild(cogwheelTwo)
            self.addChild(cogwheelThree)
            self.addChild(cogwheelFour)
            cogwheelOne.name = "cog_1"
            cogwheelTwo.name = "cog_2"
            cogwheelThree.name = "cog_3"
            cogwheelFour.name = "cog_4"
        }
        
        else {
            self.addChild(robotOne)
            robotOne.name = "robot_1"
            self.addChild(cogwheelOne)
            cogwheelOne.name = "cog_1"
        }
        
        // Robot heads (replace with graphics)
        let r1head = SKSpriteNode(imageNamed: "blueRobot")
        //let r1head = SKShapeNode(circleOfRadius: 100)
        let r2head = SKShapeNode(circleOfRadius: 10)
        let r3head = SKShapeNode(circleOfRadius: 10)
        let r4head = SKShapeNode(circleOfRadius: 10)
    
        //r1head.fillColor = SKColor.green
        r2head.fillColor = SKColor.red
        r3head.fillColor = SKColor.blue
        r4head.fillColor = SKColor.brown
        
        r1head.position = CGPoint(x: self.frame.width/2, y: 0)
        r2head.position = robotTwo.position
        r3head.position = robotThree.position
        r4head.position = robotFour.position
        
        r1head.scale(to: CGSize(width: 300, height: 300))
        r1head.zPosition = -1
        self.addChild(r1head)
        self.addChild(r2head)
        self.addChild(r3head)
        self.addChild(r4head)

        initPhysics()
        self.gameManager.initialSetUp()
        
    }
    
    // Update, called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        // Initialize _lastUpdateTime if it has not already been
        /*if (self.lastUpdateTime == 0) {
         self.lastUpdateTime = currentTime
         }
         
         // Calculate time since last update
         let dt = currentTime - self.lastUpdateTime
         
         // Update entities
         for entity in self.entities {
         entity.update(deltaTime: dt)
         }
         
         self.lastUpdateTime = currentTime*/
        
        //Checks if the goal is completed
        if (gameManager.mode == .twoplayer){
            print("inner: \(cogwheelOne.getCurrent()), outer: \(cogwheelTwo.getInner())")
            if(checkAlignment(inner: cogwheelOne, outer: cogwheelTwo)){
                print("level completed")
            }
        }else if (gameManager.mode == .fourplayer){
            if(checkAlignment(inner: cogwheelOne, outer: cogwheelTwo)
                && checkAlignment(inner: cogwheelTwo, outer: cogwheelThree)
                && checkAlignment(inner: cogwheelThree, outer: cogwheelFour)){
                print("level completed")
            }
        }
        
        
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameManager.cogRotated(cogwheel: cogwheelOne, impulse: 10)
    }
    
    

    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let aTouch = touches.first {
            
            let location = aTouch.location(in: self)
            
            let touchedNode = atPoint(location)
            
            if let nodeName = touchedNode.name {
                
                if nodeName.contains("robot") {
                    
                    if let touchedRobot = touchedNode as? Robot  {
                        let deltaX = location.x - touchedRobot.position.x
                        let deltaY = location.y - touchedRobot.position.y
                        if (abs(location.x-latestPoint.x) > abs(location.y-latestPoint.y)) {
                           
                           // print("X: ", deltaX)
                            //print("Y: ", deltaY)
                            
                            // When arm is rotated, the angle limit is set in the robot class.
                            let angle = atan2(deltaY, deltaX) + (.pi / 2)
                        
                            gameManager.armMoved(robot: touchedRobot, angle: angle)
                       
                        }else {
                            let diffY = abs(location.y-latestPoint.y)
                            if(diffY < 2){
                                if(location.y < latestPoint.y){
                                    touchedRobot.collapseArm()
                                    //touchedRobot.size.height -= 5*diffY
                                } else  if(location.y > latestPoint.y){
                                    touchedRobot.extendArm()
                                    //touchedRobot.size.height += 5*diffY
                                }
                                print(abs(location.y-latestPoint.y))
                            } else {print("Too high value")}
                        }
                    }
                }
            }
            
            // Remember this location
            latestPoint = location
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    // MARK: contact begin between two bodies
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Arrange the two bodies for easier handling
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        // Handle contact between handle and key
        
        /*if ((firstBody.categoryBitMask  & PhysicsCategory.robot != 0) && secondBody.categoryBitMask &
            PhysicsCategory.key != 0) {
            if let robot = firstBody.node as? SKSpriteNode,
                let key = secondBody.node as? SKSpriteNode{
                keyPickedUp(key: key, robot: robot)
            }
        }*/
        
        // Handle contact between handle and cogwheel
         if ((firstBody.categoryBitMask & PhysicsCategory.robot != 0) && secondBody.categoryBitMask &
            PhysicsCategory.cogwheel != 0){
            if let robot = firstBody.node as? SKSpriteNode,
                let cogwheel = secondBody.node as? SKSpriteNode {
               // cogwheel.physicsBody?.applyAngularImpulse(50)
                handleLockedIn(cogwheel: cogwheel, robot: robot)
            }
        }
    
    }
    
    // contact end
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * .pi)
    }
}


private func keyPickedUp(key: SKSpriteNode, robot: SKSpriteNode){
    //handle in game manager here
    print("key picked up")
}

private func handleLockedIn(cogwheel: SKSpriteNode, robot: SKSpriteNode){
    //handle in game manager here
    //let spinAction = SKAction.rotate(byAngle: 90, duration: 50)
    //cogwheel.run(spinAction)
   // print("handle locked in ")
}

//Checks if two cogwheels are aligned with a 5 degree margin of error
private func checkAlignment(inner: Cogwheel, outer: Cogwheel) -> Bool{
    if(abs(inner.getCurrent() - outer.getInner()) < 10){
        print("Aligned")
        return true
    }else{
        return false
    }
    
}


extension GameScene : KuggenSessionManagerDelegate {
    func gameManager(_ manager: KuggenSessionManager, impulse: CGFloat, cogName: String) {
        if cogName == "cog_1" {
            cogwheelOne.physicsBody?.applyAngularImpulse(impulse)
        }
        
        else if cogName == "cog_2" {
            cogwheelTwo.physicsBody?.applyAngularImpulse(impulse)
        }
        
        else if cogName == "cog_3" {
            cogwheelFour.physicsBody?.applyAngularImpulse(impulse)
        }
        
        else if cogName == "cog_4" {
            cogwheelFour.physicsBody?.applyAngularImpulse(impulse)
        }
            }
    
    
    func gameManager(_ manager: KuggenSessionManager, newLevel level: Level) {
        
        self.addChild(robotOne)
        self.addChild(robotTwo)
        self.addChild(robotThree)
        self.addChild(robotFour)
    }
    
    func gameManager(_ manager: KuggenSessionManager, endedLevel: Level?, success: Bool) {
        
        gameScenDelegate?.gameScene(self, didEndLevelWithSuccess: success)
    }
    
    func gameManagerGameOver(_ manager: KuggenSessionManager) {
        
    }
    
    func gameManagerNextLevel(_ manager: KuggenSessionManager) {
        
    }
    
    func sessionManager(_ manager: FourInOneSessionManager, lostPeer: MCPeerID) {
        
        
    }
    
}


