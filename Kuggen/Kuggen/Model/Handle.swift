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
    
    init(texture: SKTexture) {
        
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
    
    public func extend(){
        let speed = CGFloat(10)
        if(extended<30){
            self.position.y += speed
            extended += 1
        }
    }
    
    public func collapse(){
        let speed = CGFloat(10)
        if(extended>0){
            self.position.y -= speed
            extended -= 1
        }
    }
}
