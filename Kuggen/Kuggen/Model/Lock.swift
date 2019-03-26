class Lock {
    var matchingKey: Key
    var currentAngle: Double
    var isLocked: Bool
    
    //Creates a locked lock with specified key and angle
    init(key: Key, angle: Double) {
        matchingKey = key
        currentAngle = angle
        isLocked = true
    }
    
    //Unblocks the handle locked by the lock
    public func unBlock(){
        isLocked = false
    }
}
