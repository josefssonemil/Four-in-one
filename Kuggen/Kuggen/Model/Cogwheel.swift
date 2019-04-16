
import Foundation
import SpriteKit

class Cogwheel: SKSpriteNode{
    private var handle: HandleType
    private var outerAlignmentAngle: Double
    private var innerAlignmentAngle: Double
    private var blocker: Double?
    private var lock: Lock?
    private var currentAngle: Double
    
    //Creates a cogwheel
    init(handle: HandleType, outer: Double, inner: Double, current: Double, size: CGSize, color: UIColor){
        let texture = SKTexture(imageNamed: "purple cogwheel")
        self.handle = handle
        self.outerAlignmentAngle = outer
        self.innerAlignmentAngle = inner
        self.currentAngle = current
        super.init(texture: texture, color: color, size: size)
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
    
    //Chacks if the rotation is possible
    private func canRotate(rotation: Double) -> Bool{
        return !(lock?.isLocked ?? false)
    }
}
