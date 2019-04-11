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



    // Create robots and cogwheel properties
    private let robotOne = Robot(matchingHandle: handleOne, devicePosition: .one, textureName: "arm")
    private let robotTwo = Robot(matchingHandle: handleTwo, devicePosition: .two, textureName: "arm")
    private let robotThree = Robot(matchingHandle: handleThree, devicePosition: .three, textureName: "arm")
    private let robotFour = Robot(matchingHandle: handleFour, devicePosition: .four, textureName: "arm")
    private let cogwheelOne = Cogwheel(handle: handleOne, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black)
    private let cogwheelTwo = Cogwheel(handle: handleTwo, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black)
    private let cogwheelThree = Cogwheel(handle: handleThree, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black)
    private let cogwheelFour = Cogwheel(handle: handleFour, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black)

    
    
    

    
    // Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Initalize new scene object
    override init(size: CGSize) {
        super.init(size : size)
    }
    
    // When scene is presented by view
    override func didMove(to view: SKView) {
        // setup the scene
        initPhysics()
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
        self.gameManager.robotThree = robotThree
        self.gameManager.robotFour = robotFour
        self.gameManager.cogwheelOne = cogwheelOne
        self.gameManager.cogwheelTwo = cogwheelTwo
        self.gameManager.cogwheelThree = cogwheelThree
        self.gameManager.cogwheelFour = cogwheelFour

        
        
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
        let r1head = SKShapeNode(circleOfRadius: 10)
        let r2head = SKShapeNode(circleOfRadius: 10)
        let r3head = SKShapeNode(circleOfRadius: 10)
        let r4head = SKShapeNode(circleOfRadius: 10)
        r1head.fillColor = SKColor.black
        r2head.fillColor = SKColor.red
        r3head.fillColor = SKColor.blue
        r4head.fillColor = SKColor.brown
        
        r1head.position = robotOne.position
        r2head.position = robotTwo.position
        r3head.position = robotThree.position
        r4head.position = robotFour.position
        
        self.addChild(r1head)
        self.addChild(r2head)
        self.addChild(r3head)
        self.addChild(r4head)

    
        self.gameManager.initialSetUp()
        
    }
    
    // Update
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
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
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let spinAction = SKAction.rotate(byAngle: 90, duration: 50)
        spinAction.speed = 0.6
        cogwheelOne.run(spinAction)
        //let spinAction = SKAction.rotate(byAngle: 90, duration: 50)
        //spinAction.speed = 0.6
        //cogWheel.run(spinAction)
        //cogWheel.physicsBody?.applyAngularImpulse(50)
        //rotateCogwheel(cogwheel: cogWheel, impulse: 10)

    }
    
   /* func rotateCogwheel(cogwheel: Cogwheel, impulse: CGFloat){
        let oldRotation = cogWheel.zRotation
        print("old rotation:" + oldRotation.description)
        cogWheel.physicsBody?.applyAngularImpulse(impulse)
        let newRotation = cogWheel.zRotation
        print("new rotation:" + newRotation.description)
        gameManager.updateCogRotations(cogwheel: cogwheel, rotation: newRotation)
        
    }*/
    

    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
     
        if let aTouch = touches.first {
            
            let location = aTouch.location(in: self)
            
            
            // Check that there's som significant move
            // or else do not care about touch at all
            let diffX = abs(location.x-latestPoint.x)
            let diffY = abs(location.y-latestPoint.y)
          
            
            if diffX+diffY > limit {
                
                // Remember this location
                latestPoint = location
                
                let touchedNode = atPoint(location)
                
                if let nodeName = touchedNode.name {
                    
                    if nodeName.contains("robot") {
                        
                        if let touchedRobot = touchedNode as? Robot  {
                            let prevLoc = aTouch.previousLocation(in: self)
                            // TODO, make arm stretch
                            
                            let dx = location.x - prevLoc.x
                            let dy = location.y - prevLoc.y
                            
                            let deltaX = location.x - touchedRobot.position.x
                            let deltaY = location.y - touchedRobot.position.y
                            
                            // When arm is rotated, there should be an angle limit in both directions
                            let angle = atan2(deltaY, deltaX) - (.pi / 2)
                            
                            
                            
                            
                            gameManager.armMoved(robot: touchedRobot, angle: angle, location: location)
                            
                        }
                        
                    }
                }
                
                
            }
            else {
                
               // if kDebug {
                  //  print("skipped, small limit value")
             //   }
                
            }
            
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
    print("handle locked in ")
}



extension GameScene : KuggenSessionManagerDelegate {
    func gameManager(_ manager: KuggenSessionManager, rotAngle: CGFloat, cogwheel: Cogwheel) {
            print("cog = cog")
          //  self.cogWheel.zRotation = cogwheel.zRotation
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


