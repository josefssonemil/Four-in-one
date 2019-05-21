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
    var isExtended = false
    var shortest = CGFloat(100)
    var longest = CGFloat(800)

    init(texture: SKTexture) {
        self.rotation=0
        super.init(texture: texture, color: SKColor.white, size: texture.size())
        self.anchorPoint = CGPoint(x: 0.5,y: 0.0)
        self.setScale(0.25)
        size.height = shortest
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setPosition(x: CGFloat, y: CGFloat){
        self.position = CGPoint(x: x, y: y)
    }
    public func getY() -> CGFloat {
        return self.position.y
    }
    
    public func getX() -> CGFloat {
        return self.position.x
    }
    
    public func getHeight() -> CGFloat {
        return self.size.height
    }
    
    public func rotate(angle: CGFloat){
        zRotation=angle
        rotation=angle
    }
    
    public func extend(){
        let speed = CGFloat(10)
        
        if(size.height<longest){
            isExtended=false
            self.size.height+=speed
            //if new length is longer than max, sets new length to max
            if (size.height>longest || size.height==longest) {
                size.height=longest
                isExtended=true
            }
        } else {self.size.height = longest; isExtended=true}
        
    }
    public func extend(speed : CGFloat){
        
        if(size.height<longest){
            isExtended=false
            size.height+=speed
            //if new length is longer than max, sets new length to max
            if (size.height>longest || size.height==longest) {
                size.height=longest
                isExtended=true
            }
        }
        else {size.height = longest; isExtended=true}
        
    }
    public func collapse(speed : CGFloat){
        if(size.height>shortest){
            size.height-=speed
            isExtended = false
            if (size.height<shortest || size.height == shortest) {
                size.height = shortest
            }
        } else {size.height = shortest}
        isExtended=false
    }
    
    public func collapse(){
        let speed = CGFloat(10)
        if(size.height>shortest){
            size.height-=speed
            if (size.height<shortest || size.height == shortest) {
                size.height = shortest
                isExtended = false
            }
        } else {size.height = shortest}
        isExtended=false
    }
}
