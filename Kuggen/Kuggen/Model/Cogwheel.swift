
import Foundation
import SpriteKit

class Cogwheel: SKSpriteNode{
    private var handle: Handle
    private var outerAlignmentAngle: Double
    private var innerAlignmentAngle: Double
    private var blocker: Double?
    private var lock: Lock?
    private var currentAngle: Double
    
    init(handle: Handle, outer: Double, inner: Double, current: Double, size: CGSize, color: UIColor){
        self.handle = handle
        self.outerAlignmentAngle = outer
        self.innerAlignmentAngle = inner
        self.currentAngle = current
        super.init(texture: nil, color: color, size: size)
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
