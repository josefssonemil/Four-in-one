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
    //static let robot   : UInt32 = 0b1
   // static let cogwheel: UInt32 = 0b10
    static let key: UInt32 = 0b11
    static let lock: UInt32 = 0b111
    
    static let cogwheel1: UInt32 = 0b10
    static let cogwheel2: UInt32 = 0b10111
    static let cogwheel3: UInt32 = 0b110
    static let cogwheel4: UInt32 = 0b1010
    
    static let robot1: UInt32 = 0b1101
    static let robot2: UInt32 = 0b1111
    static let robot3: UInt32 = 0b001
    static let robot4: UInt32 = 0b0001
    
    static let alignCogOne: UInt32 = 0b0101
}

private let handleOne = HandleType.edgeCircle
private let handleTwo = HandleType.edgeSquare
private let handleThree = HandleType.edgeTrapezoid
private let handleFour = HandleType.edgeTriangle




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
    private var robotTwoHandle : Handle
    private var robotTwoArm : Arm
    private let robotTwoButton = SKShapeNode(circleOfRadius: 50)
    
    var alignmentCogOne : SKSpriteNode!
    var alignmentCogTwo : SKSpriteNode!
    var alignmentCogThree : SKSpriteNode!
    var alignmentCogFour : SKSpriteNode!
    
    private var joints : [SKPhysicsJointFixed]
  

    /*private let cogwheelOne = Cogwheel(handle: handleOne, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black)
    private let cogwheelTwo = Cogwheel(handle: handleTwo, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black)
    private let cogwheelThree = Cogwheel(handle: handleThree, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black)
    private let cogwheelFour = Cogwheel(handle: handleFour, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black)*/
    
    private let level: Level
    private let cogwheelOne: Cogwheel
    private let cogwheelTwo: Cogwheel
    private let cogwheelThree: Cogwheel
    private let cogwheelFour: Cogwheel

    
   // private var robotTwoCogwheelTwo: SKPhysicsJointPin?
    // Init
    required init?(coder aDecoder: NSCoder) {
        level = LevelReader.createLevel(nameOfLevel: "level1")
        cogwheelOne = level.cogwheels[0]
        cogwheelTwo = level.cogwheels[1]
        cogwheelThree = level.cogwheels[2]
        cogwheelFour = level.cogwheels[3]

        robotTwoArm = robotTwo.getArm()
        robotTwoHandle=robotTwo.getHandle()
        joints = []
        super.init(coder: aDecoder)
    }
    
    // Initalize new scene object


    convenience override init(size: CGSize) {
        self.init(size: size, levelNo: 1)
    }


    
    //Creates a GameScene for a specific level
    init(size: CGSize, levelNo: Int){
        level = LevelReader.createLevel(nameOfLevel: "level\(levelNo)")
        cogwheelOne = level.cogwheels[0]
        cogwheelTwo = level.cogwheels[1]
        cogwheelThree = level.cogwheels[2]
        cogwheelFour = level.cogwheels[3]
        
        robotTwoArm = robotTwo.getArm()
        robotTwoHandle=robotTwo.getHandle()
        joints = []
        super.init(size: size)
    }
    
    // When scene is presented by view
    override func didMove(to view: SKView) {
        // setup the scene
        self.view!.isMultipleTouchEnabled = true
        self.layoutScene()
    }
    
    /*override func sceneDidLoad() {
   
     }*/
    
    private func initPhysics(){
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        let cogwheels = [cogwheelOne, cogwheelTwo, cogwheelThree, cogwheelFour]
        
        //Physics for the cogwheels
        for cogwheel in cogwheels{
            cogwheel.physicsBody = SKPhysicsBody(texture: cogwheel.texture!, size: cogwheel.texture!.size())
            cogwheel.physicsBody?.isDynamic = true
            cogwheel.physicsBody?.collisionBitMask = PhysicsCategory.none
            cogwheel.physicsBody?.pinned = true
            cogwheel.physicsBody?.angularDamping = 1.0
        }
        cogwheelOne.physicsBody?.categoryBitMask = PhysicsCategory.cogwheel1
        cogwheelOne.physicsBody?.contactTestBitMask = PhysicsCategory.robot1
        cogwheelTwo.physicsBody?.categoryBitMask = PhysicsCategory.cogwheel2
        cogwheelTwo.physicsBody?.contactTestBitMask = PhysicsCategory.robot2
        cogwheelThree.physicsBody?.categoryBitMask = PhysicsCategory.cogwheel3
        cogwheelThree.physicsBody?.contactTestBitMask = PhysicsCategory.robot3
        cogwheelFour.physicsBody?.categoryBitMask = PhysicsCategory.cogwheel4
        cogwheelFour.physicsBody?.contactTestBitMask = PhysicsCategory.robot4
        
        //robot one
        robotOne.physicsBody = SKPhysicsBody(texture: robotOne.texture!, size: robotOne.texture!.size())
        robotOne.physicsBody?.isDynamic = true
        robotOne.physicsBody?.categoryBitMask = PhysicsCategory.robot1
        robotOne.physicsBody?.contactTestBitMask = PhysicsCategory.cogwheel1
        robotOne.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        /*robotTwo.physicsBody = SKPhysicsBody(texture: robotTwo.texture!, size: robotTwo.texture!.size())
        robotTwo.physicsBody?.isDynamic = true
        robotTwo.physicsBody?.categoryBitMask = PhysicsCategory.robot2
        robotTwo.physicsBody?.contactTestBitMask = PhysicsCategory.cogwheel2
        robotTwo.physicsBody?.collisionBitMask = PhysicsCategory.none*/
        
        robotTwoHandle.physicsBody = SKPhysicsBody(texture: robotTwoHandle.texture!, size: robotTwoHandle.texture!.size())
        robotTwoHandle.physicsBody?.isDynamic = true
        robotTwoHandle.physicsBody?.categoryBitMask = PhysicsCategory.robot2
        robotTwoHandle.physicsBody?.contactTestBitMask = PhysicsCategory.cogwheel2
        robotTwoHandle.physicsBody?.collisionBitMask = PhysicsCategory.none

        robotThree.physicsBody = SKPhysicsBody(texture: robotThree.texture!, size: robotThree.texture!.size())
        robotThree.physicsBody?.isDynamic = true
        robotThree.physicsBody?.categoryBitMask = PhysicsCategory.robot3
        robotThree.physicsBody?.contactTestBitMask = PhysicsCategory.cogwheel3
        robotThree.physicsBody?.collisionBitMask = PhysicsCategory.none

        robotFour.physicsBody = SKPhysicsBody(texture: robotFour.texture!, size: robotFour.texture!.size())
        robotFour.physicsBody?.isDynamic = true
        robotFour.physicsBody?.categoryBitMask = PhysicsCategory.robot4
        robotFour.physicsBody?.contactTestBitMask = PhysicsCategory.cogwheel4
        robotFour.physicsBody?.collisionBitMask = PhysicsCategory.none
        //TODO: add physics for three more cogwheel
        
        alignmentCogOne.physicsBody = SKPhysicsBody(texture: cogwheelOne.texture!, size: cogwheelOne.texture!.size())
        alignmentCogOne.physicsBody?.isDynamic = true
        alignmentCogOne.physicsBody?.categoryBitMask = PhysicsCategory.alignCogOne
        alignmentCogOne.physicsBody?.contactTestBitMask = PhysicsCategory.cogwheel1
        alignmentCogOne.physicsBody?.collisionBitMask = PhysicsCategory.none

    }
    
    // Setup the scene, add scenes and behaviours
    func layoutScene() {
        // Test
        print("Scene Setup")
        // data is sent once and is not sent again if a transmission error occurs
        gameManager.sendDataMode = .unreliable
        gameManager.delegate = self as FourInOneSessionManagerDelegate
        
        // set the background color
        self.backgroundColor = UIColor.background!
        
        // Shadows
        /*let lightNode = SKLightNode()
        //lightNode.position = CGPoint(x: (self.size.width)/2, y: (self.size.width)/2)
        lightNode.position = CGPoint(x: (self.size.width)/3, y: (self.size.width)/3)
        lightNode.categoryBitMask = 0b0001
        lightNode.falloff = 0.5
        lightNode.lightColor = UIColor.white
        //lightNode.shadowColor = UIColor.gray
        self.addChild(lightNode)
*/
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
        
        alignmentCogOne = SKSpriteNode(imageNamed: "alignmentCogBlue")
        alignmentCogOne.size = CGSize(width: 70.0, height: 100.0)
        alignmentCogOne.position = CGPoint(x: cogwheelOne.frame.maxX, y: cogwheelOne.frame.maxY)
        alignmentCogOne.zPosition = CGFloat(cogwheelOne.getCurrent())
      
        alignmentCogTwo = SKSpriteNode(imageNamed: "alignmentCogBlue")
        alignmentCogTwo.size = CGSize(width: 100.0, height: 150.0)
        alignmentCogTwo.position = CGPoint(x: cogwheelTwo.frame.maxX, y: cogwheelTwo.frame.maxY)
        
        alignmentCogThree = SKSpriteNode(imageNamed: "alignmentCogBlue")
        alignmentCogThree.size = CGSize(width: 130.0, height: 170.0)
        alignmentCogThree.position = CGPoint(x: cogwheelThree.frame.maxX, y: cogwheelThree.frame.maxY)
        
        alignmentCogFour = SKSpriteNode(imageNamed: "alignmentCogBlue")
        alignmentCogFour.size = CGSize(width: 150.0, height: 200.0)
        alignmentCogFour.position = CGPoint(x: cogwheelFour.frame.maxX, y: cogwheelFour.frame.maxY)
        
       
        
        // add nodes to scene
        if gameManager.mode == .twoplayer
        {
            self.addChild(robotOne)
            self.addChild(robotTwo)
            robotOne.name = "robot_1"
            robotTwo.name = "robot_2"
            //robotOneHandle.name = "robot_1"
            robotTwoHandle.name = "robot_2_Handle"
            self.addChild(cogwheelOne)
            self.addChild(cogwheelTwo)
            cogwheelOne.name = "cog_1"
            cogwheelTwo.name = "cog_2"
            
            /*robotOne.lightingBitMask = 1
            robotOne.shadowedBitMask = 0b0001
            
            robotTwo.lightingBitMask = 1
            robotTwo.shadowedBitMask = 0b0001
            
            cogwheelOne.lightingBitMask = 1
            cogwheelOne.shadowedBitMask = 0b0001
            
            cogwheelTwo.lightingBitMask = 1
            cogwheelTwo.shadowedBitMask = 0b0001*/
            
            self.addChild(robotOne.getArm())
            self.addChild(robotOne.getHandle())
            self.addChild(robotTwo.getHandle())
            self.addChild(robotTwo.getArm())
            
            
            self.addChild(alignmentCogOne)
            self.addChild(alignmentCogTwo)
            
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
            
            //alignmentCogOne?.position = cogwheelOne.getCurrent()
            
            self.addChild(alignmentCogOne)
            self.addChild(alignmentCogTwo)
            self.addChild(alignmentCogThree)
            self.addChild(alignmentCogFour)
        }
        
        else {
            self.addChild(robotOne)
            robotOne.name = "robot_1"
            self.addChild(cogwheelOne)
            cogwheelOne.name = "cog_1"
        }
        
        robotTwoButton.fillColor = SKColor.yellow
        robotTwoButton.position = CGPoint(x: self.frame.width/2-200, y: 100)
        robotTwoButton.name = "robotTwoButton"
        robotTwoButton.zPosition=1
        
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
        
        robotTwoButton.zPosition=2
        self.addChild(robotTwoButton)

        initPhysics()
        self.gameManager.initialSetUp()
        
        attachAlignCogs(cogwheel: cogwheelOne, cog: alignmentCogOne)
        //attachAlignCogs(cogwheel: cogwheelTwo, cog: alignmentCogTwo)
        //attachAlignCogs(cogwheel: cogwheelThree, cog: alignmentCogThree)
        //attachAlignCogs(cogwheel: cogwheelFour, cog: alignmentCogFour)
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
            
            //print("inner: \(cogwheelOne.getCurrent()), outer: \(cogwheelTwo.getInner())")
            if(checkAlignment(inner: cogwheelOne, outer: cogwheelTwo)){
                print("level completed")
                gameScenDelegate?.gameScene(self, didEndLevelWithSuccess: true)
                //gameManager.startNextLevel()
                
            }
        } else if (gameManager.mode == .fourplayer){
            if(checkAlignment(inner: cogwheelOne, outer: cogwheelTwo)
                && checkAlignment(inner: cogwheelTwo, outer: cogwheelThree)
                && checkAlignment(inner: cogwheelThree, outer: cogwheelFour)){
                print("level completed")
                gameManager.startNextLevel()

            }
        }
        
        
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameManager.cogRotated(cogwheel: cogwheelOne, impulse: 10)
        gameManager.cogRotated(cogwheel: cogwheelTwo, impulse: 10)
        /*if let aTouch = touches.first {
            
            let location = aTouch.location(in: self)
            
            let touchedNode = atPoint(location)
            
            if let nodeName = touchedNode.name {
                
                if nodeName.contains("robotTwoButton") {
                        robotTwo.closeHandle()
                }
            }
        }*/
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
                                let angle = atan2(deltaY, deltaX) + (.pi / 2)
                               // let prevHandLocX = touchedRobot.getHandle().getX()
                                // When arm is rotated, the angle limit is set in the robot class.
                                if(touchedRobot.isLockedtoCog()){
                                    if(!touchedRobot.getArm().isExtended){
                                        gameManager.cogRotated(cogwheel: touchedRobot.getCogwheel(), impulse: -angle)
                                    }
                                }
                                gameManager.armMoved(robot: touchedRobot, angle: angle)
                           
                            }else {
                                let diffY = abs(location.y-latestPoint.y)
                                if(diffY < 2){
                                    if(location.y < latestPoint.y){
                                        touchedRobot.collapseArm()
                                    } else  if(location.y > latestPoint.y){
                                        touchedRobot.extendArm()
                                    }
                                }
                        }
                    }
                }
            }
            
            // Remember this location
            latestPoint = location
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let aTouch = touches.first {
            
            let location = aTouch.location(in: self)
            
            let touchedNode = atPoint(location)
            
            if let nodeName = touchedNode.name {
                
                if nodeName.contains("robotTwoButton") {
                    robotTwo.openHandle()
                    //self.physicsWorld.removeAllJoints()
                    robotTwoHandle.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
                    robotTwoHandle.physicsBody!.angularVelocity = 0
                    if(robotTwo.isLockedtoCog()){
                        robotTwo.unLock()
                        robotTwo.getCogwheel().physicsBody?.angularVelocity=0
                        //var index = 0
                        for joint in joints {
                            self.physicsWorld.remove(joint)
                            //joints.remove(at: index)
                            //index += 1
                        }

                    }
                }
        }
    }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    // MARK: contact begin between two bodies
    func didBegin(_ contact: SKPhysicsContact) {
        
        /*let other = contact.bodyA.categoryBitMask == Contact.robot ? contact.bodyB : contact.bodyA
        
        if other.categoryBitMask == Contact.cogwheel {
            robotOne.contact(body: (other.node?.name)!)
            
            if let cogwheel = other.node as? Cogwheel {
                cogwheelOne.contact(body: robotOne.name!)
                
                print("contact")
            }
        }*/
        
        // Arrange the two bodies for easier handling
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
            //print("Contact!!!")
            
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
        if((firstBody.categoryBitMask & PhysicsCategory.robot1 != 0) && secondBody.categoryBitMask & PhysicsCategory.cogwheel1 != 0) {
            /*if let nodeName = secondBody.node?.name {
                print(nodeName)
                if nodeName.contains("robot_2") {
                    print("robot")
                    if let robot = secondBody.node as? Handle  {
                        if (robot.isClosed()){
                            handleLockedIn(cogwheel: <#T##SKSpriteNode#>, robot: <#T##SKSpriteNode#>)
                        }
                    }
                }
            }*/
            
            if let handle = secondBody.node as? Handle, let cogwheel = firstBody.node as? Cogwheel {
                if let nodeName = secondBody.node?.name {
                    //print(nodeName)
                    if nodeName.contains("robot_2") {
                        if(handle.isClosed()){
                            gameManager.cogRotated(cogwheel: cogwheelOne, impulse: 10)
                            handleLockedIn(cogwheel: cogwheel, robot: robotTwo)
                        }
                    }
                }
                
            }
        }
        
        /*if((firstBody.categoryBitMask & PhysicsCategory.robot2 != 0) && secondBody.categoryBitMask & PhysicsCategory.cogwheel2 != 0) {
            if let robot = firstBody.node as? SKSpriteNode, let cogwheel = secondBody.node as? SKSpriteNode {
                gameManager.cogRotated(cogwheel: cogwheelOne, impulse: 10)
                handleLockedIn(cogwheel: cogwheel, robot: robot)
            }
        }
        
        if((firstBody.categoryBitMask & PhysicsCategory.robot3 != 0) && secondBody.categoryBitMask & PhysicsCategory.cogwheel3 != 0) {
            if let robot = firstBody.node as? SKSpriteNode, let cogwheel = secondBody.node as? SKSpriteNode {
                gameManager.cogRotated(cogwheel: cogwheelOne, impulse: 10)
                handleLockedIn(cogwheel: cogwheel, robot: robot)
            }
        }
        
        if((firstBody.categoryBitMask & PhysicsCategory.robot4 != 0) && secondBody.categoryBitMask & PhysicsCategory.cogwheel4 != 0) {
            if let robot = firstBody.node as? SKSpriteNode, let cogwheel = secondBody.node as? SKSpriteNode {
                gameManager.cogRotated(cogwheel: cogwheelOne, impulse: 10)
                handleLockedIn(cogwheel: cogwheel, robot: robot)
            }
        }*/
        

        // Handle contact between handle and cogwheel
         /*if ((firstBody.categoryBitMask & PhysicsCategory.robot != 0) && secondBody.categoryBitMask &
            PhysicsCategory.cogwheel != 0){
            if let robot = firstBody.node as? SKSpriteNode,
                let cogwheel = secondBody.node as? SKSpriteNode {
                
               // cogwheel.physicsBody?.applyAngularImpulse(50)
                handleLockedIn(cogwheel: cogwheel, robot: robot)
            }
        }*/
    
    }
    
    // contact end
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * .pi)
    }


    private func keyPickedUp(key: SKSpriteNode, robot: SKSpriteNode){
        //handle in game manager here
        print("key picked up")
    }

    private func handleLockedIn(cogwheel: Cogwheel, robot: Robot){
        //robot.getHandle().setPosition(x: Int(cogwheel.position.x), y: Int(cogwheel.position.y))
        robot.lockToCog(cogwheel: cogwheel)
        //gameManager.cogRotated(cogwheel: cogwheel, impulse: 10)
        let robotTwoCogwheelTwo = SKPhysicsJointFixed.joint(withBodyA: robot.getHandle().physicsBody!,
                                               bodyB: cogwheel.physicsBody!,
                                               anchor: robot.getHandle().position)
        
        joints.append(robotTwoCogwheelTwo)
        self.physicsWorld.add(robotTwoCogwheelTwo)
        //handle in game manager here
        //let spinAction = SKAction.rotate(byAngle: 90, duration: 50)
        //cogwheel.run(spinAction)
       // print("handle locked in ")
    }
    
    private func attachAlignCogs(cogwheel: Cogwheel, cog: SKSpriteNode) {
        let cogToCogwheel = SKPhysicsJointFixed.joint(withBodyA: cog.physicsBody!, bodyB: cogwheel.physicsBody!, anchor: cog.position)
        joints.append(cogToCogwheel)
        self.physicsWorld.add(cogToCogwheel)
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
}


extension GameScene : KuggenSessionManagerDelegate {
    func gameManager(_ manager: KuggenSessionManager, impulse: CGFloat, cogName: String) {
        if cogName == "cog_1" {
            //cogwheelOne.physicsBody?.applyAngularImpulse(impulse)
            cogwheelOne.zRotation = impulse
        }
        
        else if cogName == "cog_2" {
            //cogwheelTwo.physicsBody?.applyAngularImpulse(impulse)
            cogwheelTwo.zRotation = impulse
        }
        
        else if cogName == "cog_3" {
            //cogwheelFour.physicsBody?.applyAngularImpulse(impulse)
            cogwheelThree.zRotation = impulse
        }
        
        else if cogName == "cog_4" {
            //cogwheelFour.physicsBody?.applyAngularImpulse(impulse)
            cogwheelFour.zRotation = impulse
        }
    }
    
   /* func gameManager(_ manager: KuggenSessionManager, impulse: CGFloat, cogName: String) {
        if cogName == "cog_1" {
            cogwheelOne.physicsBody?.angularVelocity(impulse)
        }
            
        else if cogName == "cog_2" {
            cogwheelTwo.rotate(rotation: Double(impulse))
        }
            
        else if cogName == "cog_3" {
            cogwheelFour.rotate(rotation: Double(impulse))
        }
            
        else if cogName == "cog_4" {
            cogwheelFour.rotate(rotation: Double(impulse))
        }
    }
    */
    
    
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
