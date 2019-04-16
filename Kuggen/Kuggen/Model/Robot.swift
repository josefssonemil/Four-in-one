

import Foundation
import SpriteKit
import FourInOneCore

class Robot: SKSpriteNode {
    public var matchingHandle: Handle
    var devicePosition: DevicePosition
    
    var currentArmStretch: Int
    
    //Depends on device pos
    var basePoint = CGPoint()
    private var anchorPosition = CGPoint(x: 0.5, y:0.5)
    private var rotation: CGFloat

    
    init(matchingHandle: Handle, devicePosition: DevicePosition, textureName: String) {
        let texture = SKTexture(imageNamed: textureName)
       //super.init(texture: texture, color: nil, size: texture.size())
        self.matchingHandle = matchingHandle
        self.devicePosition = devicePosition
        self.currentArmStretch = 0
        self.rotation = 0
        super.init(texture: texture, color: SKColor.white, size: texture.size())
        setup(devicePosition)

    }
    
    required init(coder aDecoder: NSCoder) {
       // super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    public func setPosition(x: Int, y: Int){
        self.position = CGPoint(x: x, y: y)
    }
    
    public func getPosition() -> CGPoint {
        return self.position
    }

    public func getY() -> Int {
        return Int(self.position.y)
    }
    
    public func getX() -> Int {
        return Int(self.position.x)
    }
    
    public func handleMovement(angle: CGFloat){
       self.zRotation = angle
    }
    
    
    private func setup(_ devicepos: DevicePosition){
        devicePosition = devicepos
        self.setScale(0.3)

       /*switch devicepos {
            //Lower left corner
            case .one:
                basePoint = CGPoint(x: 0, y: 0)
                anchorPosition.y = 0
                self.rotation = 45
                self.zRotation = rotation
            // Upper left corner
            case .two:
                basePoint = CGPoint(x: 0, y: totalScreenSize.height)
                anchorPosition.y = 1
                self.rotation = -45
                self.zRotation = rotation
            // Upper right corner
        case .three:
             basePoint = CGPoint(x: totalScreenSize.width, y: totalScreenSize.height)
             anchorPosition.y = 1
           self.rotation = 225
             self.zRotation = rotation

            // Lower right corner
        case .four:
             basePoint = CGPoint(x: totalScreenSize.width, y: 0)
            anchorPosition.y = 0
            self.rotation = 315
             self.zRotation = rotation

        }
        
        self.position = basePoint
        self.anchorPoint = anchorPosition*/
    }
    
    
    

}
