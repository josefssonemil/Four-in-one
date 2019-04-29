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
    
    private var robotOneHandle : Handle
    private var robotTwoHandle : Handle
    private var robotThreeHandle : Handle
    private var robotFourHandle : Handle
    
    private var robotTwoArm : Arm
    private let robotOneButton = SKSpriteNode(imageNamed: "robot0_button")
    private let robotTwoButton = SKSpriteNode(imageNamed: "robot1_button")
    private let robotThreeButton = SKSpriteNode(imageNamed: "robot2_button")
    private let robotFourButton = SKSpriteNode(imageNamed: "robot3_button")

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
        robotOneHandle=robotOne.getHandle()
        robotTwoHandle=robotTwo.getHandle()
        robotThreeHandle=robotThree.getHandle()
        robotFourHandle=robotFour.getHandle()
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
        robotOneHandle=robotOne.getHandle()
        robotTwoHandle=robotTwo.getHandle()
        robotThreeHandle=robotThree.getHandle()
        robotFourHandle=robotFour.getHandle()
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
        let robots = [robotOneHandle, robotTwoHandle, robotThreeHandle, robotFourHandle]
        
        //Physics for robots
        for robot in robots {
            robot.physicsBody = SKPhysicsBody(texture: robot.texture!, size: robot.frame.size)
            robot.physicsBody?.isDynamic = true
            robot.physicsBody?.collisionBitMask = PhysicsCategory.none
        }
        robotTwoHandle.physicsBody?.categoryBitMask = PhysicsCategory.robot2
        robotTwoHandle.physicsBody?.contactTestBitMask = PhysicsCategory.cogwheel2
        robotOneHandle.physicsBody?.categoryBitMask = PhysicsCategory.robot1
        robotOneHandle.physicsBody?.contactTestBitMask = PhysicsCategory.cogwheel1
        robotThreeHandle.physicsBody?.categoryBitMask = PhysicsCategory.robot3
        robotThreeHandle.physicsBody?.contactTestBitMask = PhysicsCategory.cogwheel3
        robotFourHandle.physicsBody?.categoryBitMask = PhysicsCategory.robot4
        robotFourHandle.physicsBody?.contactTestBitMask = PhysicsCategory.cogwheel4
        
        //Physics for the cogwheels
        for cogwheel in cogwheels{
            cogwheel.physicsBody = SKPhysicsBody(texture: cogwheel.texture!, size: cogwheel.frame.size)
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
        let lightNode = SKLightNode()
        //lightNode.position = CGPoint(x: (self.size.width)/2, y: (self.size.width)/2)
        lightNode.position = CGPoint(x: (self.size.width)/3, y: (self.size.width)/3)
        lightNode.categoryBitMask = 0b0001
        lightNode.falloff = 0.5
        lightNode.lightColor = UIColor.white
        //lightNode.shadowColor = UIColor.gray
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
        
        var robots : [Robot]
        var cogwheels : [Cogwheel]
        var buttons : [SKSpriteNode]
        // add nodes to scene
        if gameManager.mode == .twoplayer {
            robots = [robotOne, robotTwo]
            cogwheels = [cogwheelOne, cogwheelTwo]
            buttons = [robotOneButton, robotTwoButton]
        } else if gameManager.mode == .fourplayer{
            robots = [robotOne, robotTwo, robotThree, robotFour]
            cogwheels = [cogwheelOne, cogwheelTwo, cogwheelThree, cogwheelFour]
            buttons = [robotOneButton, robotTwoButton, robotThreeButton, robotFourButton]
        } else {
            robots = [robotOne]
            cogwheels = [cogwheelOne]
            buttons = [robotOneButton]
        }
        
        var i = 1
        for robot in robots {
            self.addChild(robot)
            self.addChild(robot.getArm())
            self.addChild(robot.getHandle())
            robot.name = "robot_\(i)"
            robot.handle.name = "robot_\(i)_handle"
            i+=1
        }
        i = 1
        for cogwheel in cogwheels {
            self.addChild(cogwheel)
            cogwheel.name = "cog_\(i)"
            cogwheel.zPosition = -1
            i+=1
        }

        
        
        var test = SKLabelNode(text: "devicepos \(gameManager.position)")
        test.fontSize = 72
        test.position = CGPoint(x: 300, y: 300)
        self.addChild(test)

 
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
        
        //r1head.position = CGPoint(x: self.frame.width/2, y: 0)
        r1head.position = robotOne.position
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
        i = 1
        for button in buttons {
            self.addChild(button)
            button.name = "robot_\(i)_button"
            button.size = CGSize(width: 100, height: 100)
            switch i {
            case 1:
                button.position = CGPoint(x: robots[i-1].position.x, y: robots[i-1].position.y)
            case 2:
                button.position = CGPoint(x: robots[i-1].position.x, y: robots[i-1].position.y)
            case 3:
                button.position = CGPoint(x: robots[i-1].position.x, y: robots[i-1].position.y)
            case 4:
                button.position = CGPoint(x: robots[i-1].position.x, y: robots[i-1].position.y)
            default:
                print("something to print")
                break
            }
            button.zPosition = 2
            i+=1
        }
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
        if let aTouch = touches.first {
            
            let location = aTouch.location(in: self)
            
            let touchedNode = atPoint(location)
            
            if let nodeName = touchedNode.name {
                
                if nodeName.contains("robot_1_button") {
                        robotOne.closeHandle()
                }
                
                if nodeName.contains("robot_2_button") {
                    robotTwo.closeHandle()
                }
                
                if nodeName.contains("robot_3_button") {
                    robotThree.closeHandle()
                }
                
                if nodeName.contains("robot_4_button") {
                    robotFour.closeHandle()
                }
            }
        }
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
        // Arrange the two bodies for easier handling
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
            print("Contact!!!")
            
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        if let bodyOne = firstBody.node!.name, let bodyTwo = secondBody.node!.name {
            print("Hjälp mig !!!!!!!")
            var cog : String
            var rob : String
            if (bodyOne.contains("cog")){
                cog = bodyOne
                rob = bodyTwo
            } else {
                cog = bodyTwo
                rob = bodyOne
            }
            switch cog {
            case "cog_1":
                if (rob == "robot_1_handle"){
                    if(robotOneHandle.isClosed()){
                        handleLockedIn(cogwheel: cogwheelOne, robot: robotOne)
                    }
                }
            case "cog_2":
                if (rob == "robot_2_handle"){
                    print("DET fungerar inte!!!!!!!!")
                    if(robotTwoHandle.isClosed()){
                        handleLockedIn(cogwheel: cogwheelTwo, robot: robotTwo)
                    }
                }
            case "cog_3":
                if (rob == "robot_3_handle"){
                    if(robotThreeHandle.isClosed()){
                        handleLockedIn(cogwheel: cogwheelThree, robot: robotThree)
                    }
                }
            case "cog_4":
                if (rob == "robot_4_handle"){
                    if(robotFourHandle.isClosed()){
                        handleLockedIn(cogwheel: cogwheelFour, robot: robotFour)
                    }
                }
            default:
                print("bajs")
                break
            }
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
       /* if((firstBody.categoryBitMask & PhysicsCategory.robot1 != 0) && secondBody.categoryBitMask & PhysicsCategory.cogwheel1 != 0) {
            if let handle = secondBody.node as? Handle, let cogwheel = firstBody.node as? Cogwheel {
                if let nodeName = secondBody.node?.name {
                    //print(nodeName)
                    if nodeName.contains("robot_1") {
                        if(handle.isClosed()){
                            //gameManager.cogRotated(cogwheel: cogwheelOne, impulse: 10)
                            handleLockedIn(cogwheel: cogwheel, robot: robotOne)
                        }
                    }
                }
                
            }
        }
        
        if((secondBody.categoryBitMask & PhysicsCategory.robot2 != 0) && firstBody.categoryBitMask & PhysicsCategory.cogwheel2 != 0) {
            if let handle = secondBody.node as? Handle, let cogwheel = firstBody.node as? Cogwheel {
                if let nodeName = secondBody.node?.name {
                    //print(nodeName)
                    if nodeName.contains("robot_2") {
                        if(handle.isClosed()){
                            //gameManager.cogRotated(cogwheel: cogwheelTwo, impulse: 10)
                            handleLockedIn(cogwheel: cogwheel, robot: robotTwo)
                        }
                    }
                }
                
            }
        }
 */
        print(firstBody.node?.name)
        print(secondBody.node?.name)
       /* if((firstBody.categoryBitMask & PhysicsCategory.robot3 != 0) && secondBody.categoryBitMask & PhysicsCategory.cogwheel3 != 0) {
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
        print("Lockedin")
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
            cogwheelOne.physicsBody?.applyAngularImpulse(impulse)
            //cogwheelOne.zRotation = impulse
        }
        
        else if cogName == "cog_2" {
            cogwheelTwo.physicsBody?.applyAngularImpulse(impulse)
            //cogwheelTwo.zRotation = impulse
        }
        
        else if cogName == "cog_3" {
            cogwheelFour.physicsBody?.applyAngularImpulse(impulse)
            //cogwheelThree.zRotation = impulse
        }
        
        else if cogName == "cog_4" {
            cogwheelFour.physicsBody?.applyAngularImpulse(impulse)
            //cogwheelFour.zRotation = impulse
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
