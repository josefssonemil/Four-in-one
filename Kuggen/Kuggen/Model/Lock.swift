
import Foundation
import SpriteKit
import FourInOneCore

class Lock: SKSpriteNode {
    var matchingKey = Key()
    var currentAngle = Double()
    var isLocked = Bool()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(matchingKey: Key, currentAngle: Double, isLocked: Bool) {
        self.matchingKey = matchingKey
        self.currentAngle = currentAngle
        self.isLocked = isLocked
        super.init(texture: nil, color: UIColor.blue, size: CGSize(width: 1.0, height: 1.0))
    }
    
    convenience override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.init(texture: texture, color: color, size: size)
    }
    
    //Unblocks the handle locked by the lock
    public func unBlock(){
        isLocked = false
    }
}
