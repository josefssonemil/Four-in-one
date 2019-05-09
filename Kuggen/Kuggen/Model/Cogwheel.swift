
import Foundation
import SpriteKit

class Cogwheel: SKSpriteNode {

    public var handle: HandleType
    var innerAlignmentAngle: Double
    var blocker: Double?
    private var lock: Lock?
    var startingAngle: CGFloat?
    //private var currentAngle: Double
    
    //Creates a cogwheel
    init(handle: HandleType, inner: Double, current: Double, size: CGSize, color: UIColor){
        let texture = SKTexture(imageNamed: "purple cogwheel")
        self.handle = handle
        self.innerAlignmentAngle = inner
        super.init(texture: texture, color: color, size: size)
        self.zRotation = 0
        self.startingAngle = CGFloat((current*Double.pi)/180)
        //self.setScale(11)
    }
    convenience init(handle: HandleType, inner: Double, current: Double, scale: Double, blocker: Double){
        self.init(handle: handle, inner: inner, current: current, scale: scale)
        self.blocker = blocker
    }
    
    init(handle: HandleType, inner: Double, current: Double, scale: Double) {
        let texture: SKTexture
        switch handle {
        case HandleType.edgeCircle:
            texture = SKTexture(imageNamed: "cogwheel4")
        case HandleType.edgeSquare:
            texture = SKTexture(imageNamed: "cogwheel2")
        case HandleType.edgeTrapezoid:
            texture = SKTexture(imageNamed: "cogwheel3")
        case HandleType.edgeTriangle:
            texture = SKTexture(imageNamed: "cogwheel1")
        default:
            texture = SKTexture(imageNamed: "purple cogwheel")
        }
        self.handle = handle
        self.innerAlignmentAngle = inner
        super.init(texture: texture, color: UIColor.black, size: CGSize(width: 100, height: 100))
        self.zRotation = 0
        self.startingAngle = CGFloat((current*Double.pi)/180)
        self.setScale(CGFloat(scale))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Rotates the cogwheel a specified angle
    /*public func rotate(rotation: Double){
        if(canRotate(rotation: rotation)){
            currentAngle += rotation
        }
    }*/
    
    //Returns the angle of the alignment gap
    public func getInner() -> Double{
        return getCurrent()
    }
    
    //Returns the angle of the alignment cog
    /*public func getOuter() -> Double{
        return
    }*/
    
    //Returns the current angle
    public func getCurrent() -> Double{
        let tempAngle: Double = ((Double(self.zRotation)*180)/Double.pi)
        return tempAngle
        /*if (tempAngle >= 0){
            return tempAngle
        }else{
            return (180 + tempAngle)
        }*/
    }
    
    //Chacks if the rotation is possible
    private func canRotate(rotation: Double) -> Bool{
        return !(lock?.isLocked ?? false)
    }
    
    /*private func setupPhysics() {
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size())
        self.physicsBody?.categoryBitMask = Contact.cogwheel
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.contactTestBitMask = 0x0
        
    }
    
    func contact(body: String) {

    }*/
}
