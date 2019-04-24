

import Foundation
import SpriteKit
import FourInOneCore

class Robot: SKSpriteNode {
    public var matchingHandle: HandleType
    var devicePosition: DevicePosition
    var handle: Handle
    var currentArmStretch: Int
    private var isLocked : Bool
    private var cogwheel : Cogwheel?
    private let isJoined = false
    
    //Depends on device pos
    var basePoint = CGPoint()
    private var anchorPosition = CGPoint(x: 0.5, y:1)
    private var rotation: CGFloat
    private var arm: Arm
   // private var arms : [Arm]
    
    private var closedHandleTexture = SKTexture(imageNamed: "robothand0closed")
    private var openHandleTexture = SKTexture(imageNamed: "robothand0open")

    init(matchingHandle: HandleType, devicePosition: DevicePosition, textureName: String) {
        let texture = SKTexture(imageNamed: textureName)
       //super.init(texture: texture, color: nil, size: texture.size())
        self.matchingHandle = matchingHandle
        self.devicePosition = devicePosition
        self.currentArmStretch = 0
        self.rotation = 0
        self.isLocked = false
        self.arm = Arm.init(texture: SKTexture(imageNamed: "robotarm1"))
        self.handle = Handle.init(texture:SKTexture(imageNamed: "robothand0open"), lengthOfArm: Double(arm.size.height))
        //self.arms = [Arm.init(texture: SKTexture(imageNamed: "robotarm1")), Arm.init(texture: SKTexture(imageNamed: "robotarm2")), Arm.init(texture: SKTexture(imageNamed: "robotarm3"))]
        super.init(texture: texture, color: SKColor.white, size: texture.size())
        setup(devicePosition)
        setPosition(pos: devicePosition)
        self.anchorPoint=anchorPosition

    }
    
    required init(coder aDecoder: NSCoder) {
       // super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    public func setPosition(x: Int, y: Int){
        self.position = CGPoint(x: x, y: y)
        arm.setPosition(x: x, y: y)
        handle.setPosition(x: x, y: y + arm.getHeight()-5)
    }
    
    public func setPosition(pos: DevicePosition){
        switch pos {
        case DevicePosition.one:
            self.position = CGPoint(x: 100 ,y: 50)
            arm.position = self.position
            handle.position = CGPoint(x: arm.position.x, y: arm.position.y + arm.frame.height)
        case DevicePosition.two:
            self.position = CGPoint(x: 100,y: totalScreenSize.height - 50)
            arm.position = self.position
            handle.position = CGPoint(x: arm.position.x, y: arm.position.y + arm.frame.height)
            self.zRotation = .pi
            arm.zRotation = .pi
            handle.zRotation = .pi
        case DevicePosition.three:
            self.position = CGPoint(x: totalScreenSize.width - 100,y:  totalScreenSize.height - 50)
            arm.position = self.position
            handle.position = CGPoint(x: arm.position.x, y: arm.position.y + arm.frame.height)
        case DevicePosition.four:
            self.position = CGPoint(x: totalScreenSize.width - 100,y:  totalScreenSize.height - 50)
            arm.position = self.position
            handle.position = CGPoint(x: arm.position.x, y: arm.position.y + arm.frame.height)
            self.zRotation = .pi
            arm.zRotation = .pi
            handle.zRotation = .pi
        default:
            break
        }
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
        if (isLocked){
            let dx = abs(arm.getX() - handle.getX())
            let dy = abs(arm.getY() - handle.getY())
            
            let length = sqrt(pow(Double(dx),2) + pow(Double(dy),2))
            let angle2 = asin(Double(dy) / length)
            
            if (Int(arm.frame.maxY)<handle.getY()){
                arm.extend(speed: CGFloat(abs(length - Double(arm.getHeight()))))

            } else {
                arm.collapse(speed: CGFloat(abs(length - Double(arm.getHeight()))))

            }
            if (handle.getX() > arm.getX()){
                arm.rotate(angle: -CGFloat(.pi/2 - angle2))
                rotation = -CGFloat(.pi/2 - angle2)
                self.zRotation = -CGFloat(.pi/2 - angle2)
            } else {
                arm.rotate(angle: CGFloat(.pi/2 - angle2))
                rotation = CGFloat(.pi/2 - angle2)
                self.zRotation = CGFloat(.pi/2 - angle2)
            }
        }
        else {
            if (.pi/3 > angle  && angle > -.pi/3){
                rotation=angle
                self.zRotation = angle
                arm.rotate(angle: angle)
                if(!isJoined){
                    if(angle<0){
                        handle.setPosition(x: Int(arm.frame.maxX), y: Int(arm.frame.maxY)-5)
                    }
                    else{
                        handle.setPosition(x: Int(arm.frame.minX), y: Int(arm.frame.maxY)-5)
                    }
                    if (.pi/4 < angle && angle < -.pi/4){
                        handle.rotate(angle: -angle/4)
                    } else { handle.rotate(angle: 0)}
                }
            }
        }
       
    }
    
    public func getArm() -> Arm{
        return self.arm
    }
    
    public func extendArm(){
        if (isLocked){
            
        }
        else{
            arm.extend()
            if(!isJoined){
                if (rotation<0){
                    handle.setPosition(x: Int(arm.frame.maxX), y: Int(arm.frame.maxY))
                }
                else{
                    handle.setPosition(x: Int(arm.frame.minX), y: Int(arm.frame.maxY))
                }
            }
        }
    }
    
    public func collapseArm(){
        if (isLocked){
        
        }
        else {
        arm.collapse()
        if(!isJoined){
            if(rotation<0){
                handle.setPosition(x: Int(arm.frame.maxX), y: Int(arm.frame.maxY))
            }
            else{
                handle.setPosition(x: Int(arm.frame.minX), y: Int(arm.frame.maxY))
            }
        }
        }
    }
    
    public func closeHandle(){
        handle.close()
        openHandleTexture = handle.texture!
        handle.texture? = closedHandleTexture
    }
    
    public func openHandle(){
        handle.open()
        closedHandleTexture = handle.texture!
        handle.texture? = openHandleTexture
    }
    
    public func lockToCog(cogwheel: Cogwheel){
        self.cogwheel = cogwheel
        isLocked=true
        
    }
    public func unLock(){
        isLocked=false
    }
    
    public func isLockedtoCog() -> Bool{
        return isLocked
    }
    
    public func getCogwheel() -> Cogwheel{
        return self.cogwheel!
    }
    private func setup(_ devicepos: DevicePosition){
        devicePosition = devicepos
        self.setScale(0.2)

        switch devicepos {
            //Lower left corner
            case .one:
                self.handle = Handle.init(texture:SKTexture(imageNamed: "robothand0open"), lengthOfArm: Double(arm.size.height))
                self.closedHandleTexture = SKTexture(imageNamed: "robothand0closed")
            // Upper left corner
            case .two:
                self.handle = Handle.init(texture:SKTexture(imageNamed: "robothand1open"), lengthOfArm: Double(arm.size.height))
                self.closedHandleTexture = SKTexture(imageNamed: "robothand1closed")

            // Upper right corner
        case .three:
            self.handle = Handle.init(texture:SKTexture(imageNamed: "robothand2open"), lengthOfArm: Double(arm.size.height))
            self.closedHandleTexture = SKTexture(imageNamed: "robothand2closed")

            // Lower right corner
        case .four:
            self.handle = Handle.init(texture:SKTexture(imageNamed: "robothand3open"), lengthOfArm: Double(arm.size.height))
            self.closedHandleTexture = SKTexture(imageNamed: "robothand3closed")
        }
        
        self.openHandleTexture = handle.texture!

               
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
