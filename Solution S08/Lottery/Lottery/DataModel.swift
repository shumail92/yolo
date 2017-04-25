//
//  DataModel.swift
//  Lottery
//
//  Created by Samy El Deib on 17/04/2017.
//  Copyright © 2017 Samy. All rights reserved.
//

import Foundation

class Draws {
    var timestamp: String
    var numbers: [String]
    
    init(timestamp: String, numbers: [String]) {
        self.timestamp = timestamp
        self.numbers = numbers
    }
}

extension Draws {
    // MARK: - Public
    class func jsonToDraws(rawDrawsObject: [String: Any]) -> Draws? {
        if
            let timestamp = rawDrawsObject["timestamp"] as? String,
            let numbers = rawDrawsObject["numbers"] as? [String]
        {
            return Draws(timestamp: timestamp, numbers: numbers)
        }
        return nil
    }
    
    class func jsonToDraws(rawJSON: Any) -> [Draws] {
        var retArr: [Draws] = []
        // Parse JSON
        if
            let jsonDict = rawJSON as? [String: Any],
            let rawDrawsArray = jsonDict["result"] as? [[String: Any]]
        {
            
            for drawObject in rawDrawsArray {
                // Parse JSON-objects into SWIFT-objects
                if let draw = jsonToDraws(rawDrawsObject: drawObject) {
                    retArr.append(draw)
                }
            }
        }
        
        return retArr
    }
    
    func toJSON() -> [String: Any] {
        var drawsObject: [String: Any] = [:]
        drawsObject["timestamp"] = timestamp
        drawsObject["numbers"] = numbers
        
        return drawsObject
    }
}

class Constants {
    public let gains = ["10'000'000","5'000'000","1'000'000"
        ,"500'000","100'000","50'000","10'000"]
    public let place = ["5*","5","4*"
        ,"4","3*","3","2*"]
}
