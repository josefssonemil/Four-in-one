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



// Used in the GameScene as an extension
protocol KuggenSessionManagerDelegate : FourInOneSessionManagerDelegate {
    
    func gameManager(_ manager: KuggenSessionManager, newLevel level:Level)
    
    func gameManager(_ manager: KuggenSessionManager, endedLevel:Level?, success:Bool)
    
    func gameManagerNextLevel(_ manager:KuggenSessionManager)
}

// This class handles the session itself and the events that are created while in the game, such
// as Key spawns and other 4-in-1 events. However, it does not handle the actual logic of the core game
// which instead handled in the model classes. Furthermore, no sprites are drawn here, they are handled
// in the gamescene by spritekit

class KuggenSessionManager: FourInOneSessionManager {

    // properties
    var level = 1
    var levelCount = 0
    var score = 0
    
    
    var kuggenDelegate: KuggenSessionManagerDelegate?

    var cogWheel: Cogwheel!
    var robotOne: Robot!
    var robotTwo: Robot!
    var robotThree: Robot!
    var robotFour: Robot!
    

    
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
        
        if mode == .twoplayer
        {
            robotOnePos = makeLocal(CGPoint(x:globalSize.width / 2, y:globalSize.width))
            
            robotTwoPos = makeLocal(CGPoint(x:globalSize.width / 2, y: 50))
            
            robotOne.setPosition(x: Int(robotOnePos.x), y: Int(robotOnePos.y))
            robotTwo.setPosition(x: Int(robotTwoPos.x), y: Int(robotTwoPos.y))
            
            robotOne.zRotation = 0
            robotTwo.zRotation = 0
        }
        
            // TODO
        else if mode == .fourplayer
        {
            robotOnePos = makeLocal(CGPoint(x:0, y:0))
            
            robotTwoPos = makeLocal(CGPoint(x:0, y:globalSize.height))
            
            robotThreePos = makeLocal(CGPoint(x:globalSize.width, y:globalSize.height))
            
            robotFourPos = makeLocal(CGPoint(x:globalSize.width, y:0))
            
            robotOne.setPosition(x: Int(robotOnePos.x), y: Int(robotOnePos.y))
            robotTwo.setPosition(x: Int(robotTwoPos.x), y: Int(robotTwoPos.y))
            robotThree.setPosition(x: Int(robotThreePos.x), y: Int(robotThreePos.y))
            robotFour.setPosition(x: Int(robotFourPos.x), y: Int(robotFourPos.y))
        }
        
    
        
    }

    // Handle touch input when the robot arm is moved
    /*func robotArmTouchMoved(robot: Robot, difference: CGPoint){
        
    }*/
    
    
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
        /*
        if shouldHandleInput(robot){
            if (isExtendArm(movement: diff.y, pos: robot.devicePosition)){
                //extend requested function here
            }
            
            else if (isWithdrawArm(movement: diff.y, pos: robot.devicePosition)){
                //withdraw requested function here
            }
        }*/
    }
    
    // Decides whether a player is withdrawing the arm  or not, depending on movement direction
    func isWithdrawArm(movement: CGFloat, pos: DevicePosition) -> Bool {
        switch pos {
        case .one:
            return movement < 0
        case .two:
            return movement > 0
        case .three:
            return movement > 0
        case .four:
            return movement < 0
        }
    }
    
    // Defines whether an input should be handled or not depending on device position

    
    func shouldHandleInput(_ robot: Robot) -> Bool {
        
        if mode == .twoplayer {
            
            switch position {
            case .one:
                
                return robot.devicePosition == .one || robot.devicePosition == .four
                
            case .two:
                
                return robot.devicePosition == .two || robot.devicePosition == .three
                
            default:
                
                return false
            }
        }
        else {
            return robot.devicePosition == self.position
            
        }
        
    }
    
    func readyForNextLevel() {
        
    }
    
    func cancelReadyForNextLevel() {
        
    }
    
    func startNextLevel() {
        
        // level += 1
        
    }
    
    // TODO : make events
    
    // Event Factory
    let moveEvent = "m"
    let moveOnlyEvent = "t"
    let levelEvent = "1"
    let endLevelEvent = "e"
    let nextLevelEvent = "n"
    let holdingEvent = "h"
    
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
