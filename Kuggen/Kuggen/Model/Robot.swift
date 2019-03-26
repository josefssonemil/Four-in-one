

import Foundation
import SpriteKit
import FourInOneCore

class Robot {
    public var matchingHandle: Handle
    private var position: CGPoint
    private var color: UIColor
    private let STARTING_POSITION: CGPoint = CGPoint.init()
    
    var devicePosition : DevicePosition
    
    //Creates a robot with a specified handle and color
    init(matchingHandle: Handle, color: UIColor, devicePosition: DevicePosition){
        self.matchingHandle = matchingHandle
        self.position = STARTING_POSITION
        self.color = color
        self.devicePosition = devicePosition
    }
    
    //Changes the position of the robot's hand
    public func setPosition(newX: Int, newY: Int) -> Void{
        position.x = CGFloat(newX);
        position.y = CGFloat(newY);
    }
    
    //Returns the position of the robot's hand
    public func getPosition() -> CGPoint{
        return position
    }
    
    //Returns the x coordinate of the robot's hand
    public func getX() -> Double{
        return Double(position.x)
    }
    
    //Returns the y coordinate of the robot's hand
    public func getY() -> Double{
        return Double(position.y)
    }
}
