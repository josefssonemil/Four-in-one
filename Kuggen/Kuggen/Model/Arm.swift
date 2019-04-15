//
//  Arm.swift
//  Kuggen
//
//  Created by Alexander Nordgren on 2019-04-15.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import Foundation
import SpriteKit
import FourInOneCore

class Arm: SKSpriteNode {
    var rotation : CGFloat
    var distanceFromOrigin : Double
    var extended : Int


    init(texture: SKTexture) {
        self.rotation=0
        self.extended = 0
        self.distanceFromOrigin=0
        super.init(texture: texture, color: SKColor.white, size: texture.size())
        self.anchorPoint = CGPoint(x: 0.5,y: 0.25)
        self.setScale(0.25)
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
    public func rotate(angle: CGFloat){
        let a = CGFloat(sqrt(2*pow(distanceFromOrigin,2)*Double(1-cos(angle))))
        self.zRotation=angle
        if(rotation<angle) {
            setPosition(x: getX() - Int(a*sin((.pi/2) - angle)), y: getY() + Int(a*sin(angle)))
        } else {
            setPosition(x: getX() + Int(a*sin((.pi/2) - angle)), y: getY() + Int(a*sin(angle)))
        }
        self.rotation=angle
    }
    
    public func extend(length: Int){
        let speed = CGFloat(10)
        if(extended<15){
            self.setPosition(x: self.getX() - Int(speed * sin(rotation)), y: self.getY() + Int(speed * sin(.pi/2 - rotation)))
            self.distanceFromOrigin += 10
            extended += 1
        }
        
    }
    
    public func collapse(length: Int){
        let speed = CGFloat(10)
        if(extended>0){
            self.setPosition(x: self.getX() + Int(speed * sin(rotation)), y: self.getY() - Int(speed * sin(.pi/2 - rotation)))
            self.distanceFromOrigin -= 10
            extended -= 1
        }
    }
}
