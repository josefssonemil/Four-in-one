//
//  LevelReader.swift
//  Kuggen
//
//  Created by Tove Ekman on 2019-03-22.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import SpriteKit



class LevelReader {
    
    private static let defaultLevel: Level = Level.init(cogwheels: [Cogwheel(handle: Handle.edgeCircle, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black), Cogwheel(handle: Handle.edgeSquare, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black), Cogwheel(handle: Handle.edgeTrapezoid, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black), Cogwheel(handle: Handle.edgeTriangle, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black)])
    
    private static func readJSONObject(object: [String: AnyObject]) -> [Cogwheel] {
        let cogwheels = object["cogwheels"] as? [[String: AnyObject]]
        var objects: [Cogwheel] = []
        for cogwheel in cogwheels! {
            guard let handle = cogwheel["handle"] as? String,
                let outer = cogwheel["outer"] as? Double,
                let inner = cogwheel["inner"] as? Double,
                let current = cogwheel["current"] as? Double else { break }
            var handle1: Handle
            switch handle{
            case "edgeSquare":
                handle1 = Handle.edgeSquare
            case "edgeTrapezoid":
                handle1 = Handle.edgeTrapezoid
            case "edgeCircle":
                handle1 = Handle.edgeCircle
            case "edgeTriangle":
                handle1 = Handle.edgeTriangle
            default:
                handle1 = Handle.edgeSquare
            }
            objects.append(Cogwheel.init(handle: handle1, outer: outer, inner: inner, current: current))
            //print(Cogwheel.init(handle: handle1, outer: outer, inner: inner, current: current))
        }
        //print(Level.init(cogwheels: objects).getNumberOfCogwheels())
        return objects
    }
    
    static func createLevel(nameOfLevel : String) -> Level {
        if let path = Bundle.main.path(forResource: nameOfLevel, ofType: "json") {
            do {
                print("Level - 1")
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                print("Level - 2")
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
                print("LevelReader Succeded")
                return Level.init(cogwheels: readJSONObject(object: jsonResult as! [String : AnyObject]))
            } catch {
                // handle error
            }
        }else {
            print("Error in LevelReader-1")
            return defaultLevel
            
        }
        print("Error in LevelReader-2")
        return defaultLevel
    }
}


