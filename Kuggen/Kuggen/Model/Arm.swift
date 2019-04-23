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
    var isExtended = false


    init(texture: SKTexture) {
        self.rotation=0
        self.extended = 0
        self.distanceFromOrigin=0
        super.init(texture: texture, color: SKColor.white, size: texture.size())
        self.anchorPoint = CGPoint(x: 0.5,y: 0.0)
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
    
    public func getHeight() -> Int{
        return Int(self.size.height)
    }
    
    public func rotate(angle: CGFloat){
        //let a = CGFloat(sqrt(2*pow(distanceFromOrigin,2)*Double(1-cos(angle))))
        self.zRotation=angle
        /*if(rotation<angle) {
            setPosition(x: getX() - Int(a*sin((.pi/2) - angle)), y: getY() + Int(a*sin(angle)))
        } else {
            setPosition(x: getX() + Int(a*sin((.pi/2) - angle)), y: getY() + Int(a*sin(angle)))
        }*/
        self.rotation=angle
    }
    
    public func extend(){
        let speed = CGFloat(10)
        
        if(extended<450){
            isExtended=false
         /*   self.setPosition(x: self.getX() - Int(speed * sin(rotation)), y: self.getY() + Int(speed * sin(.pi/2 - rotation)))
            self.distanceFromOrigin += 10*/
            self.size.height+=speed
            extended += 10
        } else { extended=450; isExtended = true}
        
    }
    public func extend(speed : CGFloat){
        if(extended<450){
            isExtended=false
            /*   self.setPosition(x: self.getX() - Int(speed * sin(rotation)), y: self.getY() + Int(speed * sin(.pi/2 - rotation)))
             self.distanceFromOrigin += 10*/
            self.size.height+=speed
            extended += Int(speed)
        }
        else {extended = 450; isExtended=true}
        
    }
    public func collapse(speed : CGFloat){
        if(extended>0){
            isExtended=false
            /*   self.setPosition(x: self.getX() - Int(speed * sin(rotation)), y: self.getY() + Int(speed * sin(.pi/2 - rotation)))
             self.distanceFromOrigin += 10*/
            self.size.height-=speed
            extended -= Int(speed)
        } else { extended=0 }
        
    }
    
    public func collapse(){
        let speed = CGFloat(10)
        if(extended>0){
            isExtended=false
            self.size.height-=speed
            /*self.setPosition(x: self.getX() + Int(speed * sin(rotation)), y: self.getY() - Int(speed * sin(.pi/2 - rotation)))
            self.distanceFromOrigin -= 10*/
            extended -= 10
        } else { extended=0}
    }
    
}
