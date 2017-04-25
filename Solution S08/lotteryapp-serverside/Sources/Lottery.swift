import Foundation

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import MongoDB
import libmongoc

let numberOfDatabaseField = 2

/**
 Parsing json to a bson according to Lottery Scheme.
 
 - return: Optional BSON
 */
func createLotteryBSON(json: [String:  Any]) -> BSON? {
    let bsonAndNoOfFields = createPartialLotteryBSON(json: json)
    
    if bsonAndNoOfFields.1 != numberOfDatabaseField {
        return nil
    }
    
    return bsonAndNoOfFields.0
}


func createPartialLotteryBSON(json: [String: Any]) -> (BSON?, Int) {
    var numberOfFields: Int = 0;
    
    let bson = BSON()
    var bsonCild: BSON
    
    for (key, value) in json {
        switch key {
        case "timestamp":
            if let timestamp = value as? String {
                numberOfFields += 1
                bson.append(key: "timestamp", string: timestamp)
            } else {
                return (nil, -1)
            }
            
        case "numbers":
            if let numbers = value as? [String] {
                numberOfFields += 1
                
                bsonCild = BSON()
                for (index, number) in numbers.enumerated() {
                    bsonCild.append(key: "\(index)", string: number)
                }
                _ = bson.appendArray(key: "numbers", array: bsonCild)
            } else {
                return (nil, -1)
            }
            
        default:
            return (nil, -1)
        }
    }
    
    return (bson, numberOfFields)
}
