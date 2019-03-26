
import Foundation
import SpriteKit

class Cogwheel{
    private var handle: Handle
    private var outerAlignmentAngle: Double
    private var innerAlignmentAngle: Double
    private var blocker: CGPoint? //Change to double
    private var lock: Lock?
    private var currentAngle: Double
    private var size: Double
    
    init(handle: Handle, outer: Double, inner: Double, current: Double, size: Double){
        self.handle = handle
        self.outerAlignmentAngle = outer
        self.innerAlignmentAngle = inner
        self.currentAngle = current
        self.size = size
    }
    //TODO: Add inits
    
    //Rotates the cogwheel a specified angle
    public func rotate(rotation: Double){
        if(canRotate(rotation: rotation)){
            currentAngle += rotation
        }
    }
    
    //Chacks if the rotation is possible
    private func canRotate(rotation: Double) -> Bool{
        //TODO
        return true
    }
}
