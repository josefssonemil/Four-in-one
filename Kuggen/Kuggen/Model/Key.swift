import SpriteKit

class Key {
    var matchingLock: Lock
    var position: CGPoint
    
    //Creates a key with a specified lock and position
    init(lock: Lock, pos: CGPoint) {
        matchingLock = lock
        position = pos
    }

}
