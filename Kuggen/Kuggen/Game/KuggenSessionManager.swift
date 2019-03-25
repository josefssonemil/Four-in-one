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
        
        //Robot creation
        
        // TODO - add colors
        /*
        robotOne = Robot(matchingHandle: matchingHandleOne)
        robotTwo = Robot(matchingHandle: matchingHandleTwo)
        robotThree = Robot(matchingHandle: matchingHandleThree)
        robotFour = Robot(matchingHandle: matchingHandleFour)

    */
        
        // Starting points for each robot
        
        let robotOnePos = makeLocal(CGPoint(x:0, y:0))
        
        let robotTwoPos = makeLocal(CGPoint(x:0, y:globalSize.height))
        
        let robotThreePos = makeLocal(CGPoint(x:globalSize.width, y:globalSize.height))
        
        let robotFourPos = makeLocal(CGPoint(x:globalSize.width, y:0))
        
        // Set starting positions
        
        // TODO - decide whether positions should be int or floats
        /*
        robotOne.setPosition(newX: robotOnePos.x, newY: robotOnePos.y)
        robotTwo.setPosition(newX: robotTwoPos.x, newY: robotTwoPos.y)
        robotThree.setPosition(newX: robotThreePos.x, newY: robotThreePos.y)
        robotFour.setPosition(newX: robotFourPos.x, newY: robotFourPos.y)

        */
    }

    // Handle touch input when the robot arm is moved
    /*func robotArmTouchMoved(robot: Robot, difference: CGPoint){
        
    }*/
    
    
    /*
    func getRobot(atPos: DevicePosition){
        switch atPos {
        case .one:
            return robotOne
        case .two
            return robotTwo
        case .three
            return robotThree
        case .four
            return robotFour
        }
    }
    */
    
    
    
    
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

    /*
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
        
    }*/
    
    // TODO : make events
    
    

}
