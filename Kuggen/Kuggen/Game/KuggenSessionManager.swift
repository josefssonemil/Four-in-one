//
//  KuggenSessionManager.swift
//  Kuggen
//
//  Created by Emil Josefsson on 2019-03-12.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit
import FourInOneCore
import MultipeerConnectivity
import SpriteKit



// Used in the GameScene as an extension
protocol KuggenSessionManagerDelegate : FourInOneSessionManagerDelegate {
        
    func gameManager(_ manager: KuggenSessionManager, newLevel level:Level)
    
    func gameManager(_ manager: KuggenSessionManager, endedLevel:Level?, success:Bool)
    
    func gameManagerNextLevel(_ manager:KuggenSessionManager)
    
    func gameManager(_ manager: KuggenSessionManager, impulse: CGFloat, cogName: String)
}


class KuggenSessionManager: FourInOneSessionManager {
    
    weak var coordinator: MainCoordinator?

    // properties
    var level = 1
    var levelCount = 0
    var score = 0
    var rotationCount = 0
    
    var kuggenDelegate: KuggenSessionManagerDelegate?

    var cogwheelOne: Cogwheel!
    var cogwheelTwo: Cogwheel!
    var cogwheelThree: Cogwheel!
    var cogwheelFour: Cogwheel!
    var robotOne: Robot!
    var robotTwo: Robot!
    var robotThree: Robot!
    var robotFour: Robot!
    var alignmentCogOne : SKSpriteNode!
    var alignmentCogTwo : SKSpriteNode!
    var alignmentCogThree : SKSpriteNode!
    var alignmentCogFour : SKSpriteNode!
    

    
    var matchingHandleOne: Handle!
    var matchingHandleTwo: Handle!
    var matchingHandleThree: Handle!
    var matchingHandleFour: Handle!


    
    var globalSize: CGSize!
    
    override public var delegate: FourInOneSessionManagerDelegate? {
        get { return self.kuggenDelegate }
        set { self.kuggenDelegate = newValue as! KuggenSessionManagerDelegate? }
    }
    
    // Sets up the board size and robot positions
    func initialSetUp(){
        // The entire board including all devices
        globalSize = makeBoardSize()
    
        // Starting points for each robot
        var robotOnePos: CGPoint
         var robotTwoPos: CGPoint
         var robotThreePos: CGPoint
         var robotFourPos: CGPoint
        
        var cogwheelOnePos: CGPoint
        var cogwheelTwoPos: CGPoint
        var cogwheelThreePos: CGPoint
        var cogwheelFourPos: CGPoint
        
        var alignmentCogOnePos: CGPoint
        //var alignmentCogTwoPos: CGPoint
        //var alignmentCogThreePos: CGPoint
        //var alignmentCogFourPos: CGPoint
        
        if mode == .twoplayer
        {
            robotOnePos = makeLocal(CGPoint(x:globalSize.width / 2, y: globalSize.height - 100))
            robotTwoPos = makeLocal(CGPoint(x:globalSize.width / 2 + 150, y: 100))

            robotOne.setPosition(x: Int(robotOnePos.x), y: Int(robotOnePos.y))
            robotTwo.setPosition(x: Int(robotTwoPos.x), y: Int(robotTwoPos.y))
            
            robotOne.zRotation = .pi
            robotTwo.zRotation = 0
            
            cogwheelOnePos = makeLocal(CGPoint(x: globalSize.width / 2, y: globalSize.height / 2))
            cogwheelOne.position.x = cogwheelOnePos.x
            cogwheelOne.position.y = cogwheelOnePos.y
            
            cogwheelTwoPos = makeLocal(CGPoint(x: globalSize.width / 2, y: globalSize.height / 2))
            cogwheelTwo.position.x = cogwheelTwoPos.x
            cogwheelTwo.position.y = cogwheelTwoPos.y
            
            //alignmentCogOnePos = makeLocal(CGPoint(x: cogwheelOne.frame.maxX, y: cogwheelOne.frame.maxY ))
            //alignmentCogOne = SKSpriteNode(imageNamed: "alignmentCogBlue")
            //alignmentCogOne.size = CGSize(width: 100.0, height: 150.0)
            //alignmentCogOne.position.x = alignmentCogOnePos.x
            //talignmentCogOne.position.y = alignmentCogOnePos.y
        }
        
            // TODO
        else if mode == .fourplayer
        {
            
            globalSize = makeBoardSize()
            
            robotOne.position = makeLocal(CGPoint(x:350, y:150))
            robotOne.setPosition(pos: robotOne.position, devpos: DevicePosition.one)
            
            robotTwo.position = makeLocal(CGPoint(x:150, y:globalSize.height-350))
            robotTwo.setPosition(pos: robotTwo.position, devpos: DevicePosition.two)
            
            robotThree.position = makeLocal(CGPoint(x:globalSize.width-350, y:globalSize.height-150))
            robotThree.setPosition(pos: robotThree.position, devpos: DevicePosition.three)
            
            robotFour.position = makeLocal(CGPoint(x:globalSize.width-150, y:350))
            robotFour.setPosition(pos: robotFour.position, devpos: DevicePosition.four)
            
            /*robotOnePos = makeLocal(CGPoint(x:0, y:0))
            /*robotOnePos = CGPoint(x:0, y:0)
            robotTwoPos = CGPoint(x: 0, y: globalSize.height)
            robotThreePos = CGPoint(x:globalSize.width, y:globalSize.height)
            robotFourPos = CGPoint(x:globalSize.width, y:0)*/
            
           
            robotTwoPos = makeLocal(CGPoint(x:0, y:globalSize.height))
            
           robotThreePos = makeLocal(CGPoint(x:globalSize.width, y:globalSize.height))
            
            robotFourPos = makeLocal(CGPoint(x:globalSize.width, y:0))
            */
           /* robotOne.setPosition(x: Int(robotOnePos.x), y: Int(robotOnePos.y))
            robotTwo.setPosition(x: Int(robotTwoPos.x), y: Int(robotTwoPos.y))
            robotThree.setPosition(x: Int(robotThreePos.x), y: Int(robotThreePos.y))
            robotFour.setPosition(x: Int(robotFourPos.x), y: Int(robotFourPos.y))*/
            
            cogwheelOnePos = makeLocal(CGPoint(x: globalSize.width / 2, y: globalSize.height / 2 ))
            cogwheelOne.position.x = cogwheelOnePos.x
            cogwheelOne.position.y = cogwheelOnePos.y
            
            cogwheelTwoPos = makeLocal(CGPoint(x: globalSize.width / 2, y: globalSize.height / 2 ))
            cogwheelTwo.position.x = cogwheelTwoPos.x
            cogwheelTwo.position.y = cogwheelTwoPos.y
            
            cogwheelThreePos = makeLocal(CGPoint(x: globalSize.width / 2, y: globalSize.height / 2))
            cogwheelThree.position.x = cogwheelThreePos.x
            cogwheelThree.position.y = cogwheelThreePos.y
            
            cogwheelFourPos = makeLocal(CGPoint(x: globalSize.width / 2, y: globalSize.height / 2))
            cogwheelFour.position.x = cogwheelFourPos.x
            cogwheelFour.position.y = cogwheelFourPos.y
            
            
        }
        
    
        
    }
    
    private func randomizeStartingAngles() {
        
    }

    // Handle touch input when the robot arm is moved
    /*func robotArmTouchMoved(robot: Robot, difference: CGPoint){
        
    }*/
    
    func cogRotated(cogwheel: Cogwheel, impulse: CGFloat) {
        
        if cogwheel.name == "cog_1"{
            synchronizeRotation(impulse: impulse, cogName: cogwheel.name!)
        }
        
        else if cogwheel.name == "cog_2" {
            synchronizeRotation(impulse: impulse, cogName: cogwheel.name!)
        }
        
        else if cogwheel.name == "cog_3" {
            synchronizeRotation(impulse: impulse, cogName: cogwheel.name!)
        }
        
        else if cogwheel.name == "cog_4" {
            synchronizeRotation(impulse: impulse, cogName: cogwheel.name!)
        }
        
    }
    /* Overridden in SessionServer and SessionClient*/
    func synchronizeRotation(impulse: CGFloat, cogName: String) {
     
    }
    
    
    
    
    // TODO - robot objects need to contain devicepositions
    
    func getRobot(atPos: DevicePosition) -> Robot {
        switch atPos {
        case .one:
            return robotOne
        case .two:
            return robotTwo
        case .three:
            return robotThree
        case .four:
            return robotFour
        }
    }
    
    
    
    
    
    // Decides whether a player is dragging the arm out or not, depending on movement direction
    func isExtendArm(movement: CGFloat, pos: DevicePosition) -> Bool{
        switch pos {
        case .one:
            return movement > 0
        case .two:
            return movement < 0
        case .three:
            return movement < 0
        case .four:
            return movement > 0
            
        }
    }
    
    func armMoved(robot: Robot, angle: CGFloat){
        robot.handleMovement(angle: angle)
    }
    


    func readyForNextLevel() {
        
    }
    
    func cancelReadyForNextLevel() {
        
    }
    
    func startNextLevel() {
        
        
        // level += 1
        
    }
    
    
    // Event Factory
    let moveEvent = "m"
    let moveOnlyEvent = "t"
    let levelEvent = "1"
    let endLevelEvent = "e"
    let nextLevelEvent = "n"
    let holdingEvent = "h"
    let cogRotationEvent = "c"
    
    let peerKey = "a"
    let impulseKey = "x"
    let nameKey = "z"
    let positionKey = "p"
    let levelKey = "v"
    let scoreKey = "s"
    let boolKey = "o"
    let intKey = "i"
    let oneKey = "1"
    let twoKey = "2"
    let threeKey = "3"
    let fourKey = "4"
    
    func makeMoveEvent(center:CGPoint) -> FourInOneEvent {
        var event = FourInOneEvent()
        
        event.type = moveOnlyEvent
        event.info = [positionKey:NSCoder.string(for: center)]
        
        return event
    }
    
    
    
    func makeCogRotation(impulse: CGFloat, cogName: String) -> FourInOneEvent {
        var event = FourInOneEvent()
        event.type = cogRotationEvent
        let peerInfo = self.peerId.displayName
        event.info = [impulseKey: impulse.description, nameKey: cogName, peerKey: peerInfo]
        return event
    }
    
    func makeMoveEvent(center:CGPoint, one:Int, two:Int, three:Int, four:Int) -> FourInOneEvent {
        
        var event = FourInOneEvent()
        
        event.type = moveEvent
        event.info = [positionKey:NSCoder.string(for: center),
                      oneKey:String(one), twoKey:String(two), threeKey:String(three), fourKey:String(four)]
        
        return event
        
    }
    
    func makeLevelEvent(level:Level, count:Int) -> FourInOneEvent {
        
        var event = FourInOneEvent()
        event.type = levelEvent
        
        /*if let json = level.JSONString() {
            event.info = [levelKey:json, intKey:String(count)]
        }*/
        
        return event
    }
    
    func makeEndLevelEvent(score:Int) -> FourInOneEvent {
        
        var event = FourInOneEvent()
        event.type = endLevelEvent
        event.info = [scoreKey:String(score)]
        
        return event
        
    }
    
    func makeNextLevelEvent() -> FourInOneEvent {
        
        var event = FourInOneEvent()
        event.type = nextLevelEvent
        
        return event

    }
    
    func makeHoldingEvent(on:Bool) -> FourInOneEvent {
        
        var event = FourInOneEvent()
        
        event.type = holdingEvent
        event.info = [boolKey:on.description]
        
        return event
        
    }
}
