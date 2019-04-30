//
//  Handle.swift
//  Kuggen
//
//  Created by Alexander Nordgren on 2019-04-16.
//  Copyright © 2019 Four-in-one. All rights reserved.
//
import Foundation
import SpriteKit
import FourInOneCore

class Handle: SKSpriteNode{
    private var anchorLocation = CGPoint(x: 0.5, y: 0)
    var extended : Int
    var rotation : CGFloat
    var distanceFromOrigin : Double
    var isHandleClosed : Bool
    var handle: HandleType
    
    private var closedHandleTexture = SKTexture(imageNamed: "robothand0closed")
    private var openHandleTexture = SKTexture(imageNamed: "robothand0open")
    
    init(lengthOfArm: Double, handle: HandleType) {
        rotation=0
        distanceFromOrigin=lengthOfArm
        extended=0
        isHandleClosed = false
        self.handle = handle
        super.init(texture: openHandleTexture, color: SKColor.white, size: openHandleTexture.size())
        setHandle(handle: handle)
        self.anchorPoint = anchorLocation
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setPosition(x: Int, y: Int){
        self.position = CGPoint(x: x, y: y)
    }
    
    private func setHandle(handle: HandleType) {
        switch handle {
        case .edgeCircle:
            texture = SKTexture(imageNamed: "robothand0open")
            closedHandleTexture = SKTexture(imageNamed:"robothand0closed")
        case .edgeSquare:
            texture = SKTexture(imageNamed: "robothand2open")
            closedHandleTexture = SKTexture(imageNamed:"robothand2closed")
        case .edgeTriangle:
            texture = SKTexture(imageNamed: "robothand1open")
            closedHandleTexture = SKTexture(imageNamed:"robothand1closed")
        case .edgeTrapezoid:
            texture = SKTexture(imageNamed: "robothand3open")
            closedHandleTexture = SKTexture(imageNamed:"robothand3closed")
        }
        openHandleTexture = self.texture!

    }
    
    public func getY() -> Int {
        return Int(self.position.y)
    }
    
    public func getX() -> Int {
        return Int(self.position.x)
    }
    
    
    public func rotate(angle : CGFloat){
        self.zRotation=angle
        self.rotation=angle
    }
    
    public func close(){
        self.texture = closedHandleTexture
        isHandleClosed=true
    }
    
    public func open(){
        self.texture = openHandleTexture
        isHandleClosed=false
    }
    
    public func isClosed() -> Bool {
        return isHandleClosed
    }
}
