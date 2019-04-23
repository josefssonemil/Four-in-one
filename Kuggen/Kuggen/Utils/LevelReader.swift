//
//  LevelReader.swift
//  Kuggen
//
//  Created by Tove Ekman on 2019-03-22.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import SpriteKit



class LevelReader {
    
    //The level that is returnded if there is an error in the LevelReader
    private static let defaultLevel: Level = Level.init(cogwheels: [Cogwheel(handle: Handle.edgeCircle, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black), Cogwheel(handle: Handle.edgeSquare, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black), Cogwheel(handle: Handle.edgeTrapezoid, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black), Cogwheel(handle: Handle.edgeTriangle, inner: 1.0, current: 1.0, size: CGSize.init(width: 100.0, height: 100.0), color: SKColor.black)])
    
    //Creates a list of cogwheels from the raw data of the JSON file
    private static func readJSONObject(object: [String: AnyObject]) -> [Cogwheel] {
        let cogwheels = object["cogwheels"] as? [[String: AnyObject]]
        var objects: [Cogwheel] = []
        for cogwheel in cogwheels! {
            guard let handleString = cogwheel["handle"] as? String,
                let inner = cogwheel["inner"] as? Double,
                let current = cogwheel["current"] as? Double,
                let scale = cogwheel["scale"] as? Double else { break }
            var handle: Handle
            switch handleString{
            case "edgeSquare":
                handle = Handle.edgeSquare
            case "edgeTrapezoid":
                handle = Handle.edgeTrapezoid
            case "edgeCircle":
                handle = Handle.edgeCircle
            case "edgeTriangle":
                handle = Handle.edgeTriangle
            default:
                handle = Handle.edgeSquare
            }
            objects.append(Cogwheel.init(handle: handle, inner: inner, current: current, scale: scale))
            //print(Cogwheel.init(handle: handle1, outer: outer, inner: inner, current: current))
        }
        //print(Level.init(cogwheels: objects).getNumberOfCogwheels())
        return objects
    }
    
    //Creates a Level from a JSON file
    static func createLevel(nameOfLevel : String) -> Level {
        if let path = Bundle.main.path(forResource: nameOfLevel, ofType: "json") {
            do {
                //print("Level - 1")
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                //print("Level - 2")
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


