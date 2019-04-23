
import Foundation
import SpriteKit

class Cogwheel: SKSpriteNode{
    private var handle: Handle
    private var innerAlignmentAngle: Double
    private var blocker: Double?
    private var lock: Lock?
    //private var currentAngle: Double
    
    //Creates a cogwheel
    init(handle: Handle, inner: Double, current: Double, size: CGSize, color: UIColor){
        let texture = SKTexture(imageNamed: "purple cogwheel")
        self.handle = handle
        self.innerAlignmentAngle = inner
        super.init(texture: texture, color: color, size: size)
        self.zRotation = CGFloat((current*Double.pi)/180)
        self.setScale(11)
    }
    
    init(handle: Handle, inner: Double, current: Double, scale: Double) {
        let texture = SKTexture(imageNamed: "purple cogwheel")
        self.handle = handle
        self.innerAlignmentAngle = inner
        super.init(texture: texture, color: UIColor.black, size: CGSize(width: 100, height: 100))
        self.zRotation = CGFloat((current*Double.pi)/180)
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
        let tempAngle = getCurrent() + innerAlignmentAngle
        if(tempAngle >= 360){
            return (tempAngle - 360)
        }else{
            return tempAngle
        }
    }
    
    //Returns the angle of the alignment cog
    /*public func getOuter() -> Double{
        return
    }*/
    
    //Returns the current angle
    public func getCurrent() -> Double{
        let tempAngle: Double = ((Double(self.zRotation)*180)/Double.pi)
        if (tempAngle >= 0){
            return tempAngle
        }else{
            return (180 + tempAngle)
        }
    }
    
    //Chacks if the rotation is possible
    private func canRotate(rotation: Double) -> Bool{
        return !(lock?.isLocked ?? false)
    }
}
