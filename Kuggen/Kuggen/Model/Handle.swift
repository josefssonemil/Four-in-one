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
    
    init(texture: SKTexture, lengthOfArm: Double) {
        rotation=0
        distanceFromOrigin=lengthOfArm
        extended=0
        isHandleClosed = false
        super.init(texture: texture, color: SKColor.white, size: texture.size())
        self.anchorPoint = anchorLocation
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setPosition(x: Int, y: Int){
        self.position = CGPoint(x: x, y: y)
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
        //self.texture = SKTexture(imageNamed: "robothand1closed")
        isHandleClosed=true
    }
    
    public func open(){
       // self.texture = SKTexture(imageNamed: "robothand1open")
        isHandleClosed=false
    }
    
    public func isClosed() -> Bool {
        return isHandleClosed
    }
}
