

import Foundation
import SpriteKit
import FourInOneCore

class Robot: SKSpriteNode {
    public var matchingHandle: HandleType
    var devicePosition: DevicePosition
    var handle: Handle
    var currentArmStretch: Int
    
    //Depends on device pos
    var basePoint = CGPoint()
    private var anchorPosition = CGPoint(x: 0.5, y:1)
    private var rotation: CGFloat
    private var arm: Arm
   // private var arms : [Arm]

    
    init(matchingHandle: HandleType, devicePosition: DevicePosition, textureName: String) {
        let texture = SKTexture(imageNamed: textureName)
       //super.init(texture: texture, color: nil, size: texture.size())
        self.matchingHandle = matchingHandle
        self.devicePosition = devicePosition
        self.currentArmStretch = 0
        self.rotation = 0
        self.arm = Arm.init(texture: SKTexture(imageNamed: "robotarm1"))
        self.handle = Handle.init(texture:SKTexture(imageNamed: "robothand0open"), lengthOfArm: Double(arm.size.height))
        //self.arms = [Arm.init(texture: SKTexture(imageNamed: "robotarm1")), Arm.init(texture: SKTexture(imageNamed: "robotarm2")), Arm.init(texture: SKTexture(imageNamed: "robotarm3"))]
        super.init(texture: texture, color: SKColor.white, size: texture.size())
        setup(devicePosition)
        self.anchorPoint=anchorPosition

    }
    
    required init(coder aDecoder: NSCoder) {
       // super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    public func setPosition(x: Int, y: Int){
        self.position = CGPoint(x: x, y: y)
        arm.setPosition(x: x, y: y)
        handle.setPosition(x: x, y: y + arm.getHeight())
        /*for arm in arms{
            arm.setPosition(x: x, y: y)
            print("x: ", x)
            print("y: ", y)
        }*/
    }
    
    public func getHandle() -> Handle{
        return handle
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
        if (.pi/3 > angle  && angle > -.pi/3){
            rotation=angle
            self.zRotation = angle
            arm.rotate(angle: angle)
            if(angle<0){
                handle.setPosition(x: Int(arm.frame.maxX), y: Int(arm.frame.maxY))
                handle.rotate(angle: -angle)
            }
            else{
                handle.setPosition(x: Int(arm.frame.minX), y: Int(arm.frame.maxY))
                handle.rotate(angle: -angle/2)
            }
            
            /*for arm in arms{
                arm.rotate(angle: angle)
            }*/
        }
    }
    
    public func getArm() -> Arm{
        return self.arm
    }
    
    public func extendArm(){
        arm.extend()
        if(rotation<0){
            handle.setPosition(x: Int(arm.frame.maxX), y: Int(arm.frame.maxY))
        }
        else{
            handle.setPosition(x: Int(arm.frame.minX), y: Int(arm.frame.maxY))
        }
        //arms[2].extend(length: length)
    }
    
    public func collapseArm(){
        arm.collapse()
        if(rotation<0){
            handle.setPosition(x: Int(arm.frame.maxX), y: Int(arm.frame.maxY))
        }
        else{
            handle.setPosition(x: Int(arm.frame.minX), y: Int(arm.frame.maxY))
        }
        //arms[2].collapse(length: length)
    }
    
    public func closeHandle(){
        handle.close()
    }
    
    public func openHandle(){
        handle.open()
    }
    
    private func setup(_ devicepos: DevicePosition){
        devicePosition = devicepos
        self.setScale(0.2)


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
    
    /*private func setupPhysics(){
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size())
        self.physicsBody?.categoryBitMask = Contact.robot
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.contactTestBitMask = 0x0
    }
    
    // MARK_ - Contact
    func contact(body: String) {
        if body == Spritename.robot1 {
        }
        
        if body == Spritename.robot2 {
        }
        
        if body == Spritename.robot3 {
        }
        
        if body == Spritename.robot4 {
        }
    }*/
}
