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
protocol GameSceneDelegate: AnyObject {
    func changeLevel(gameManager: KuggenSessionManager, result:Bool)
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
    
    static let alignCog1: UInt32 = 0b0101
    static let alignCog2: UInt32 = 0b0011
    static let alignCog3: UInt32 = 0b0111
    static let alignCog4: UInt32 = 0b0100
}

private let handleOne = HandleType.edgeCircle
private let handleTwo = HandleType.edgeSquare
private let handleThree = HandleType.edgeTrapezoid
private let handleFour = HandleType.edgeTriangle

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Game manager, create and manage request objects
    var gameManager : KuggenSessionManager!
    weak var gameSceneDelegate : GameSceneDelegate?
    private var latestPoint = CGPoint()
    var limit : CGFloat = 6.0
    
    var currentlyActiveRobotTouches = [UITouch: Robot]()
    
    // Create robot arms and cogwheel properties
    private let robotOne = Robot(matchingHandle: handleOne, devicePosition: .one, textureName: "fingerprint")
    private let robotTwo = Robot(matchingHandle: handleTwo, devicePosition: .two, textureName: "fingerprint")
    private let robotThree = Robot(matchingHandle: handleThree, devicePosition: .three, textureName: "fingerprint")
    private let robotFour = Robot(matchingHandle: handleFour, devicePosition: .four, textureName: "fingerprint")
    
    private var robotOneHandle : Handle
    private var robotTwoHandle : Handle
    private var robotThreeHandle : Handle
    private var robotFourHandle : Handle
    
    var alignmentCogOne = SKSpriteNode(imageNamed: "alignmentCogGreen")
    var alignmentCogTwo = SKSpriteNode(imageNamed: "alignmentCogPink")
    var alignmentCogThree = SKSpriteNode(imageNamed: "alignmentCogBlue")
    var alignmentCogFour = SKSpriteNode(imageNamed: "alignmentCogPurple")
    
    private var robotTwoArm : Arm
    private let robotOneButton = SKSpriteNode(imageNamed: "robot0_button")
    private let robotTwoButton = SKSpriteNode(imageNamed: "robot1_button")
    private let robotThreeButton = SKSpriteNode(imageNamed: "robot2_button")
    private let robotFourButton = SKSpriteNode(imageNamed: "robot3_button")
    
    private var joints : [SKPhysicsJointFixed]
    
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
        
        let alignCogs = [alignmentCogOne,alignmentCogTwo,alignmentCogThree,alignmentCogFour]
        
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
        
        for alignCog in alignCogs{
            alignCog.physicsBody = SKPhysicsBody(texture: alignCog.texture!, size: alignCog.frame.size)
            alignCog.physicsBody?.isDynamic = true
            alignCog.physicsBody?.collisionBitMask = PhysicsCategory.none
        }
    }
    
    // Setup the scene, add scenes and behaviours
    func layoutScene() {
        // Test
        print("Scene Setup")
        // data is sent once and is not sent again if a transmission error occurs
        gameManager.sendDataMode = .unreliable
        gameManager.delegate = self as FourInOneSessionManagerDelegate
        gameManager.sendDataMode = .reliable
        // set the background color
        self.backgroundColor = UIColor.background!
        
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
        let alignCogs: [SKSpriteNode]
        // add nodes to scene
        if gameManager.mode == .twoplayer {
            robots = [robotOne, robotTwo]
            cogwheels = [cogwheelOne, cogwheelTwo]
            buttons = [robotOneButton, robotTwoButton]
            alignCogs = [alignmentCogOne, alignmentCogTwo]
        } else if gameManager.mode == .fourplayer{
            robots = [robotOne, robotTwo, robotThree, robotFour]
            cogwheels = [cogwheelOne, cogwheelTwo, cogwheelThree, cogwheelFour]
            buttons = [robotOneButton, robotThreeButton, robotFourButton, robotTwoButton]
            alignCogs = [alignmentCogOne, alignmentCogTwo, alignmentCogThree, alignmentCogFour]
        } else {
            robots = [robotOne]
            cogwheels = [cogwheelOne]
            buttons = [robotOneButton]
            alignCogs = [alignmentCogOne]
        }
        
        var i = 1
        for robot in robots {
            self.addChild(robot)
            self.addChild(robot.getArm())
            self.addChild(robot.getHandle())
            robot.name = "robot_\(i)"
            robot.handle.name = "robot_\(i)_handle"
            robot.handle.zPosition = 2
            i+=1
        }
        i = 1
        for cogwheel in cogwheels {
            self.addChild(cogwheel)
            cogwheel.name = "cog_\(i)"
            cogwheel.zPosition = -1
            i+=1
        }
        
        self.gameManager.initialSetUp()
        
        i = 0
        for aligncog in alignCogs {
            aligncog.size = CGSize(width: 80.0, height: 120.0)
            aligncog.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            aligncog.position = CGPoint(x: cogwheels[i].position.x + cogwheels[i].size.height/2, y: cogwheels[i].position.y)
            aligncog.zRotation = -.pi/2
            aligncog.zPosition = 1
            addChild(aligncog)
            i+=1
        }
        
        
        initPhysics()
        
        i=0
        for aligncog in alignCogs {
            attachAlignCogs(cogwheel: cogwheels[i], cog: aligncog)
            i+=1
        }
        
        
        let heads = [SKSpriteNode(imageNamed: "robothead0"),SKSpriteNode(imageNamed: "robothead2"),SKSpriteNode(imageNamed: "robothead3"),SKSpriteNode(imageNamed: "robothead1")]
        
        i = 1
        var deX = CGFloat(0)
        var deY = CGFloat(0)
        for button in buttons {
            //LAYOUT FOR THE ROBOT HEADS
            self.addChild(heads[i-1])
            heads[i-1].scale(to: CGSize(width: 300, height: 300))
            heads[i-1].zPosition = -1
            heads[i-1].anchorPoint = CGPoint(x: 0.0, y: 1.0)
            heads[i-1].isUserInteractionEnabled = false
            button.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            
            self.addChild(button)
            button.name = "robot_\(i)_button"
            button.size = CGSize(width: 100, height: 100)
            print("delta X = \(deX)")
            print("delta Y = \(deY)")
            switch i {
            case 1:
                button.position = CGPoint(x: robots[i-1].position.y, y: robots[i-1].position.x)
                deX = abs(robots[i-1].position.x - button.position.x)
                deY = abs(robots[i-1].position.y - button.position.y)
                button.zRotation = -.pi/4
            case 2:
                button.position = CGPoint(x: robots[i-1].position.y - 100, y: totalScreenSize.height - robots[i-1].position.x)
                button.zRotation = (-3 * .pi)/4
            case 3:
                button.position = CGPoint(x: robots[i-1].position.x + deX, y: robots[i-1].position.y - deY)
                button.zRotation = (3 * .pi)/4
            case 4:
                button.position = CGPoint(x: (totalScreenSize.width - totalScreenSize.height) + robots[i-1].position.y + 100, y: totalScreenSize.width - robots[i-1].position.x)
                button.zRotation = .pi/4
            default:
                break
            }    
            heads[i-1].position = button.position
            heads[i-1].zRotation = button.zRotation
            button.zPosition = 2
            hideOther(self.gameManager, heads: heads, robots: robots)
            i+=1
        }
        if (self.gameManager.isServer) {
            initStartingRotations(cogs: cogwheels)
        }
        
        initConstraints(robots: robots)
    }
    
    
    private func initConstraints(robots: [Robot]){
        
        // Bind handles and arms in screen size
        let hHeight = robotOne.handle.size.height
        let xRange = SKRange(lowerLimit: 0, upperLimit: (gameManager.globalSize.width / 2) - hHeight)
        let yRange = SKRange(lowerLimit: 0, upperLimit: (gameManager.globalSize.height / 2) - hHeight)
        let regionConstraint = SKConstraint.positionX(xRange, y: yRange)
        
        
        // Always rotate handle to center
        print("width: \(gameManager.globalSize.width), height: \(gameManager.globalSize.height / 2)")
        let point = CGPoint(x:gameManager.globalSize.width/2, y: 0)
        //let point = CGPoint(
        let normalizedPoint = gameManager.makeLocal(point)
        
        for robot in robots {
            robot.getArm().constraints = [regionConstraint]
            robot.handle.constraints = [regionConstraint]
            robot.rotationRanges = [xRange, yRange]
        }
        
        
    }
    
    private func initStartingRotations(cogs: [Cogwheel]){
        
        
        let delayInSeconds = 3.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            for cog in cogs {
                self.gameManager.cogRotated(cogwheel: cog, impulse: cog.startingAngle!)
                //Vänta tills kugghjulen roterat klart
                DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds){
                    let serverManager = self.gameManager as? KuggenSessionServer
                    serverManager?.readyToPlay(bool: true)
                    self.gameManager.readyToPlay = true
                    print("ready to play")
                }
            }
        }
    }
    
    // Update, called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        if (gameManager.readyToPlay) {
            //Checks if the goal is completed
            if (gameManager.mode == .twoplayer){
                //print("inner: \(cogwheelOne.getCurrent()), outer: \(cogwheelTwo.getInner())")
                if(checkAlignment(inner: cogwheelOne, outer: cogwheelTwo)){
                    print("level completed")
                    gameSceneDelegate?.changeLevel(gameManager: self.gameManager, result: true)
                    self.isPaused = true
                }
            } else if (gameManager.mode == .fourplayer){
                if(checkAlignment(inner: cogwheelOne, outer: cogwheelTwo)
                    && checkAlignment(inner: cogwheelTwo, outer: cogwheelThree)
                    && checkAlignment(inner: cogwheelThree, outer: cogwheelFour)){
                    print("level completed")
                    gameSceneDelegate?.changeLevel(gameManager: self.gameManager, result: true)
                    self.isPaused = true
                }
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let aTouch = touches.first {
            
            let location = aTouch.location(in: self)
            
            let touchedNode = atPoint(location)
            
            if let nodeName = touchedNode.name {
                
                print("touchednode")
                print(touchedNode)
                if let robot = touchedNode as? Robot {
                    currentlyActiveRobotTouches[aTouch] = robot
                    print(currentlyActiveRobotTouches)
                }
                
                switch nodeName {
                case "robot_1_button":
                    robotOne.closeHandle()
                case "robot_2_button":
                    robotTwo.closeHandle()
                case "robot_3_button":
                    robotThree.closeHandle()
                case "robot_4_button":
                    robotFour.closeHandle()
                default:
                    break
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let aTouch = touches.first {
            
            let location = aTouch.location(in: self)
            
            var activeRobot: Robot?
            if let event = event {
                let matchingTouches = currentlyActiveRobotTouches.filter { touch in
                    return (event.allTouches ?? []).contains(touch.key)
                }
                if let touch = matchingTouches.first {
                    activeRobot = touch.value
                }
            }
            
            let isMovingAnActiveRobot = activeRobot != nil
            
            if let nodeName = Optional("n") {
                if nodeName.contains("robot") || isMovingAnActiveRobot {
                    if isMovingAnActiveRobot {
                        let touchedRobot = activeRobot!
                        
                        let deltaX = location.x - touchedRobot.position.x
                        let deltaY = location.y - touchedRobot.position.y
                        let angle = atan2(deltaY, deltaX) + (.pi / 2)
                        
                        if (touchedRobot.rotation - 10 * .pi/180 < angle && angle < touchedRobot.rotation + 10 * .pi/180){

                            if (CGPointDistance(from: latestPoint, to: touchedRobot.position) < CGPointDistance(from: location, to: touchedRobot.position)){
                                touchedRobot.collapseArm()
                            } else{
                                touchedRobot.extendArm()
                            }
                        }
                        
                        if(touchedRobot.isLockedtoCog()){
                            
                            let normalizedAngle = angle - touchedRobot.zRotation
                            let armLength = touchedRobot.getArm().size.height
                            
                            let aAngle = (.pi - normalizedAngle) / 2
                            
                            let distance = (sin(normalizedAngle) * armLength) / sin(aAngle)
                            
                            let cogRadius = touchedRobot.getCogwheel().size.height / 2
                            
                            let rotationAngle = (distance / 2) / cogRadius
                            
                            if(!touchedRobot.getArm().isExtended && touchedRobot.isRotationAllowed){
                                
                                if !(touchedRobot.handle.position.x >= touchedRobot.rotationRanges![0].upperLimit || touchedRobot.handle.position.y >= touchedRobot.rotationRanges![1].upperLimit) {
                                    gameManager.cogRotated(cogwheel: touchedRobot.getCogwheel(), impulse: -rotationAngle / 2)
                                }
                            }
                        }
                        gameManager.armMoved(robot: touchedRobot, angle: angle)
                    }
                }
            }
            
            // Remember this location
            latestPoint = location
        }
        
    }
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let aTouch = touches.first {
            
            let location = aTouch.location(in: self)
            
            let touchedNode = atPoint(location)
            
            if let event = event {
                let matchingTouches = currentlyActiveRobotTouches.filter { touch in
                    return (event.allTouches ?? []).contains(touch.key)
                }
                if let touch = matchingTouches.first {
                    currentlyActiveRobotTouches.removeValue(forKey: touch.key)
                }
            }
            
            if let nodeName = touchedNode.name {
                
                switch nodeName {
                case "robot_1_button":
                    robotOne.openHandle()
                    if (robotOne.isLockedtoCog()){
                        unlockFromCog(handle: robotOneHandle)
                        robotOne.unLock()
                        robotOne.physicsBody?.angularVelocity = 0
                    }
                case "robot_2_button":
                    robotTwo.openHandle()
                    if (robotTwo.isLockedtoCog()){
                        unlockFromCog(handle: robotTwoHandle)
                        robotTwo.unLock()
                        robotTwo.physicsBody?.angularVelocity = 0
                    }
                case "robot_3_button":
                    robotThree.openHandle()
                    if (robotThree.isLockedtoCog()){
                        unlockFromCog(handle: robotThreeHandle)
                        robotThree.unLock()
                        robotThree.physicsBody?.angularVelocity = 0
                    }
                case "robot_4_button":
                    robotFour.openHandle()
                    if (robotFour.isLockedtoCog()){
                        unlockFromCog(handle: robotFourHandle)
                        robotFour.unLock()
                        robotFour.physicsBody?.angularVelocity = 0
                    }
                default:
                    break
                }
            }
        }
    }
    
    private func unlockFromCog(handle: Handle){
        var i = 0
        for joint in joints {
            if (joint.bodyA.node!.name!.contains(handle.name!)){
                physicsWorld.remove(joint)
                if i < joints.count{
                    joints.remove(at: i)
                }
            } else if (joint.bodyB.node!.name!.contains(handle.name!)){
                physicsWorld.remove(joint)
                if i < joints.count{
                    joints.remove(at: i)
                }
            }
            i += 1
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
            
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if let bodyOne = firstBody.node!.name, let bodyTwo = secondBody.node!.name {
            if (bodyOne.contains("robot") || bodyTwo.contains("robot")){
                if (bodyOne.contains("cog") && bodyTwo.contains("robot")){
                    checkPhysics(cog: firstBody.node! as! Cogwheel, rob: secondBody.node! as! Handle)
                } else if (bodyTwo.contains("cog") && bodyOne.contains("robot")){
                    checkPhysics(cog: secondBody.node! as! Cogwheel, rob: firstBody.node! as! Handle)
                }
            }
        }
    }
    
    private func checkPhysics(cog: Cogwheel, rob: Handle) {
        if (cog.handle == rob.handle && rob.isClosed()){
            switch rob.name {
            case "robot_1_handle":
                handleLockedIn(cogwheel: cog, robot: robotOne)
            case "robot_2_handle":
                handleLockedIn(cogwheel: cog, robot: robotTwo)
            case "robot_3_handle":
                handleLockedIn(cogwheel: cog, robot: robotThree)
            case "robot_4_handle":
                handleLockedIn(cogwheel: cog, robot: robotFour)
            default:
                break
            }
        }
    }
    
    // contact end
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * .pi)
    }
    
    
    private func keyPickedUp(key: SKSpriteNode, robot: SKSpriteNode){
        //handle in game manager here
        
    }
    
    private func handleLockedIn(cogwheel: Cogwheel, robot: Robot){
        robot.lockToCog(cogwheel: cogwheel)
        
        
        
        /* let jointBetweenObjects = SKPhysicsJointFixed.joint(withBodyA: robot.getHandle().physicsBody!,
         bodyB: cogwheel.physicsBody!,
         anchor: robot.getHandle().position)
         
         joints.append(jointBetweenObjects)
         self.physicsWorld.add(jointBetweenObjects)*/
        
    }
    
    private func attachAlignCogs(cogwheel: Cogwheel, cog: SKSpriteNode) {
        let cogToCogwheel = SKPhysicsJointFixed.joint(withBodyA: cogwheel.physicsBody!, bodyB: cog.physicsBody!, anchor: cog.position)
        
        self.physicsWorld.add(cogToCogwheel)
        
    }
    
    
    //Checks if two cogwheels are aligned with a 5 degree margin of error
    private func checkAlignment(inner: Cogwheel, outer: Cogwheel) -> Bool{
        if(abs(inner.getCurrent() - outer.getInner()) < 5){
            print("Aligned \(inner.getCurrent()), \(outer.getCurrent())")
            return true
        }else{
            return false
        }
        
    }
    
    //hides the the other robotss
    private func hideOther(_ manager: KuggenSessionManager, heads: [SKSpriteNode], robots: [Robot]){
        let pos = manager.position
        
        switch pos {
        case .one:
            heads[1].isHidden = true
            
            robots[1].getArm().isHidden = true
            robots[1].getHandle().isHidden = true
            
            if(gameManager.mode == .fourplayer){
                heads[2].isHidden = true
                heads[3].isHidden = true
                
                robots[2].getArm().isHidden = true
                robots[2].getHandle().isHidden = true
                
                robots[3].getArm().isHidden = true
                robots[3].getHandle().isHidden = true
            }
            
        case .two:
            heads[0].isHidden = true
            
            robots[0].getArm().isHidden = true
            robots[0].getHandle().isHidden = true
            
            if(gameManager.mode == .fourplayer){
                heads[2].isHidden = true
                heads[3].isHidden = true
                
                robots[2].getArm().isHidden = true
                robots[2].getHandle().isHidden = true
                
                robots[3].getArm().isHidden = true
                robots[3].getHandle().isHidden = true
            }
        case .three:
            heads[0].isHidden = true
            heads[1].isHidden = true
            
            robots[0].getArm().isHidden = true
            robots[0].getHandle().isHidden = true
            
            robots[1].getArm().isHidden = true
            robots[1].getHandle().isHidden = true
            
            if(gameManager.mode == .fourplayer){
                heads[3].isHidden = true
                
                robots[3].getArm().isHidden = true
                robots[3].getHandle().isHidden = true
            }
        case .four:
            heads[0].isHidden = true
            heads[1].isHidden = true
            
            robots[0].getArm().isHidden = true
            robots[0].getHandle().isHidden = true
            
            robots[1].getArm().isHidden = true
            robots[1].getHandle().isHidden = true
            
            if(gameManager.mode == .fourplayer){
                heads[2].isHidden = true
                
                robots[2].getArm().isHidden = true
                robots[2].getHandle().isHidden = true
            }
            
        }
    }
}


extension GameScene : KuggenSessionManagerDelegate {
    
    func gameManager(_ manager: KuggenSessionManager, impulse: CGFloat, cogName: String) {
        if (manager.rotationCount < 4 )
        {
            let rotateAction = SKAction.rotate(toAngle: impulse
                , duration: 2)
            if cogName == "cog_1" {
                //cogwheelOne.physicsBody?.applyAngularImpulse(impulse)
                //cogwheelOne.zRotation = impulse
                cogwheelOne.run(rotateAction)
            }
                
            else if cogName == "cog_2" {
                //cogwheelTwo.physicsBody?.applyAngularImpulse(impulse)
                //cogwheelTwo.zRotation = impulse
                cogwheelTwo.run(rotateAction)
            }
                
            else if cogName == "cog_3" {
                //cogwheelThree.physicsBody?.applyAngularImpulse(impulse)
                //cogwheelThree.zRotation = impulse
                cogwheelThree.run(rotateAction)
            }
                
            else if cogName == "cog_4" {
                //cogwheelFour.physicsBody?.applyAngularImpulse(impulse)
                //  cogwheelFour.zRotation = impulse
                cogwheelFour.run(rotateAction)
            }
            gameManager.rotationCount += 1
        } else {
            
            //var cog : Cogwheel
            //cog = cogwheelOne
            if cogName == "cog_1" {
                //cogwheelOne.physicsBody?.applyAngularImpulse(impulse)
                //cog = cogwheelOne
                cogwheelOne.zRotation += impulse
                
            }
                
            else if cogName == "cog_2" {
                //cogwheelTwo.physicsBody?.applyAngularImpulse(impulse)
                //cog = cogwheelTwo
                cogwheelTwo.zRotation += impulse
                
            }
                
            else if cogName == "cog_3" {
                //cogwheelThree.physicsBody?.applyAngularImpulse(impulse)
                //cog = cogwheelThree
                cogwheelThree.zRotation += impulse
                
            }
                
            else if cogName == "cog_4" {
                //cogwheelFour.physicsBody?.applyAngularImpulse(impulse)
                //cog = cogwheelFour
                cogwheelFour.zRotation += impulse
            }
            
            
        }
    }
    
    
    
    
    
    func gameManager(_ manager: KuggenSessionManager, newLevel level: Level) {
        
        self.addChild(robotOne)
        self.addChild(robotTwo)
        self.addChild(robotThree)
        self.addChild(robotFour)
    }
    
    func gameManager(_ manager: KuggenSessionManager, endedLevel: Level?, success: Bool) {
        
        //gameScenDelegate?.gameScene(gameManager: self.gameManager, result: success)
    }
    
    func gameManagerGameOver(_ manager: KuggenSessionManager) {
        
    }
    
    func gameManagerNextLevel(_ manager: KuggenSessionManager) {
        
    }
    
    func sessionManager(_ manager: FourInOneSessionManager, lostPeer: MCPeerID) {
        

    }
    
}
