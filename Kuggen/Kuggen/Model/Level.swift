//
//  Level.swift
//  Kuggen
//
//  Created by Alexander Nordgren on 2019-03-27.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import Foundation

class Level{
    var cogwheels: [Cogwheel]
    var key: Key?
    
    init(cogwheels: [Cogwheel]) {
        self.cogwheels=cogwheels
    }
    
    init(cogwheels: [Cogwheel], key: Key) {
        self.cogwheels=cogwheels
        self.key=key
    }
    
    func getNumberOfCogwheels() -> Int {
        return cogwheels.count
    }
}
