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
    
    init(texture: SKTexture, lengthOfArm: Double) {
        rotation=0
        distanceFromOrigin=lengthOfArm
        extended=0
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
    
    
    public func extend(armLength: Double){
        let speed = CGFloat(10)
        if(extended<30){
            self.position.y += speed
            extended += 1
            distanceFromOrigin=armLength
        }
    }
    
    public func collapse(armLength: Double){
        let speed = CGFloat(10)
        if(extended>0){
            self.position.y -= speed
            extended -= 1
            distanceFromOrigin=armLength
        }
    }
    
    public func rotate(angle : CGFloat){
        //let a = CGFloat(sqrt(2*pow(distanceFromOrigin, 2)*Double(1-cos(angle))))
        //let a = CGFloat(sqrt(2*pow(distanceFromOrigin,2)*Double(1-cos(angle))))
        self.zRotation=angle
        if(rotation<angle) {
        // setPosition(x: getX() - Int(a*sin((.pi-angle)/2)), y: getY() - Int(a*sin((.pi/2)-(.pi-angle)/2)))
         } else {
         //setPosition(x: getX() + Int(a*sin((.pi-angle)/2)), y: getY() - Int(a*sin((.pi/2)-(.pi-angle)/2)))
         }
        self.rotation=angle
    }
    
    public func close(){
        self.texture = SKTexture(imageNamed: "robothand1closed")
    }
    
    public func open(){
        self.texture = SKTexture(imageNamed: "robothand1open")
    }
}
