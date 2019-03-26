//
//  LevelReader.swift
//  Kuggen
//
//  Created by Tove Ekman on 2019-03-22.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import SpriteKit



class LevelReader {
    static func createLevel() {
        if let path = Bundle.main.path(forResource: "test", ofType: "JSON") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? NSDictionary {
                    if let personArray = jsonResult.value(forKey: "mjau") as? NSArray {
                        for (_, element) in personArray.enumerated() {
                            if let element = element as? NSDictionary {
                                let name = element.value(forKey: "name") as! String
                                let age = element.value(forKey: "age") as! String
                                let employed = element.value(forKey: "employed") as! String
                                print("Name: \(name),  age: \(age), employed: \(employed)")
                            }
                        }
                    }
                }
            } catch {
                // handle error
            }
        }
    }
}


