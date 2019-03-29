import Foundation
import SpriteKit
import FourInOneCore

class Key: SKSpriteNode {
    var matchingLock = Lock()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //Creates a key with a specified lock and position
    
    init(matchingLock: Lock) {
        self.matchingLock = matchingLock
        super.init(texture: nil, color: UIColor.green, size: CGSize(width: 1.0, height: 1.0))
    }
    
    convenience override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.init(texture: texture, color: color, size: size)
    }
    
    public func setPosition(x: Int, y: Int){
        self.position = CGPoint(x: x, y: y)
    }
    
    public func getPosition() -> CGPoint {
        return self.position
    }

}
