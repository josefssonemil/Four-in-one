

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

    
    init(matchingHandle: Handle, devicePosition: DevicePosition, color: UIColor) {
        //let texture = SKTexture(imageNamed: "ball")
       //super.init(texture: texture, color: nil, size: texture.size())
        self.matchingHandle = matchingHandle
        self.devicePosition = devicePosition
        self.stretch = 0
        super.init(texture: nil, color: color, size: CGSize(width: 50, height: 50))
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
    
    private func setup(_ devicepos: DevicePosition){
        devicePosition = devicepos
        
        switch devicepos {
            //Lower left corner
            case .one:
                basePoint = CGPoint(x: 0, y: 0)
                anchorPosition.y = 0
                rotation = 45
            
            // Upper left corner
            case .two:
                basePoint = CGPoint(x: 0, y: totalScreenSize.height)
                anchorPosition.y = 1
                rotation = -45
            // Upper right corner
        case .three:
             basePoint = CGPoint(x: totalScreenSize.width, y: totalScreenSize.height)
             anchorPosition.y = 1
            rotation = 225
            // Lower right corner
        case .four:
             basePoint = CGPoint(x: totalScreenSize.width, y: 0)
            anchorPosition.y = 0
            rotation = 315
        }
        
        self.position = basePoint
        self.anchorPoint = anchorPosition
    }
    
    
    
   /* public var matchingHandle: Handle
    //private var position: CGPoint
    //private var color: UIColor
    private let STARTING_POSITION: CGPoint = CGPoint.init()
    
    var devicePosition : DevicePosition
    
    //Creates a robot with a specified handle and color
    init(matchingHandle: Handle, color: UIColor, devicePosition: DevicePosition){
        self.matchingHandle = matchingHandle
        self.position = STARTING_POSITION
        self.color = color
        self.devicePosition = devicePosition
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super .init(texture: texture, color: color, size: size)
    }
    
    convenience init(matchingHandle: Handle, color: UIColor, devicePosition: DevicePosition) {
        
       let texture = GameTextures.sharedInstance.texture(name: SpriteName.rope)
       self.init(texture: texture, color: SKColor.white, size: texture.size())
       // setup(position)
    }
    //Changes the position of the robot's hand
    public func setPosition(newX: CGFloat, newY: CGFloat) -> Void{
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
    }*/

}
