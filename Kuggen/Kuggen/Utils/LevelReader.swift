//
//  LevelReader.swift
//  Kuggen
//
//  Created by Tove Ekman on 2019-03-22.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import SpriteKit



class LevelReader {
    
    private static func readJSONObject(object: [String: AnyObject]) {
        let cogwheels = object["cogwheels"] as? [[String: AnyObject]]
        
        for cogwheel in cogwheels! {
            guard let handle = cogwheel["handle"] as? String,
                let outer = cogwheel["outer"] as? Double,
                let inner = cogwheel["inner"] as? Double,
                let current = cogwheel["current"] as? Double,
                let size = cogwheel["size"] as? Double else { break }
            print(handle)
            print(outer)
            print(inner)
            print(current)
            print(size)
            
        }
    }
    
    static func createLevel() {
        if let path = Bundle.main.path(forResource: "test", ofType: "JSON") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
                    readJSONObject(object: jsonResult as! [String : AnyObject])
            } catch {
                // handle error
            }
        }
    }
}


