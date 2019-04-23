
import Foundation
import SpriteKit

class Cogwheel: SKSpriteNode{
    private var handle: Handle
    private var outerAlignmentAngle: Double
    private var innerAlignmentAngle: Double
    private var blocker: Double?
    private var lock: Lock?
    private var currentAngle: Double
    
    //Creates a cogwheel
    init(handle: Handle, outer: Double, inner: Double, current: Double, size: CGSize, color: UIColor){
        let texture = SKTexture(imageNamed: "purple cogwheel")
        self.handle = handle
        self.outerAlignmentAngle = outer
        self.innerAlignmentAngle = inner
        self.currentAngle = current
        super.init(texture: texture, color: color, size: size)
        self.setScale(11)
    }
    
    init(handle: Handle, outer: Double, inner: Double, current: Double) {
        let texture = SKTexture(imageNamed: "purple cogwheel")
        self.handle = handle
        self.outerAlignmentAngle = outer
        self.innerAlignmentAngle = inner
        self.currentAngle = current
        super.init(texture: texture, color: UIColor.black, size: CGSize(width: 100, height: 100))
        self.setScale(11)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Rotates the cogwheel a specified angle
    public func rotate(rotation: Double){
        if(canRotate(rotation: rotation)){
            currentAngle += rotation
        }
    }
    
    //Returns the angle of the alignment gap
    public func getInner() -> Double{
        return innerAlignmentAngle
    }
    
    //Returns the angle of the alignment cog
    public func getOuter() -> Double{
        return outerAlignmentAngle
    }
    
    //Returns the current angle
    public func getCurrent() -> Double{
        return currentAngle
    }
    
    //Chacks if the rotation is possible
    private func canRotate(rotation: Double) -> Bool{
        return !(lock?.isLocked ?? false)
    }
}
