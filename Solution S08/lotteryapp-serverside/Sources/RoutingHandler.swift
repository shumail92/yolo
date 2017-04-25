import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import MongoDB
import libmongoc


// MARK: - Helper Functions

/**
 Use the response object to reponse back to the request server by setting the message and
 response status code.
 
 - parameter response: https response object
 - parameter status: response status whether it failed or successed according HTTP status codes
 */
func reply(response: HTTPResponse, status: HTTPResponseStatus, message: String) {
    let jsonString = "{\"result\": \(message)}"
    
    response.status = status
    response.setHeader(.contentType, value: "application/json")
        .appendBody(string: jsonString)
        .completed()
}

/**
 Parse the response of MongoDB functions to a message, which states whether the opperation was
 successful or not, and statusCode which corresponds to the message.
 
 - parameter response: https response object
 - parameter status: response status whether it failed or successed according HTTP status codes
 
 - returns: tuple of a messages and httpstatus code
 */
func parseMongoResult(result: MongoResult, defaultAction: (String, HTTPResponseStatus))
    -> (String, HTTPResponseStatus) {
    
    var message = defaultAction.0
    var statusCode = defaultAction.1

    switch result {
    case .success:
        message = "Success"
        statusCode = HTTPResponseStatus.ok

    default:
        message = "Failure"
        statusCode = HTTPResponseStatus.internalServerError
    }
    
    return(message, statusCode)
}

// MARK: - Routing Handlers
/**
 GET request handler
 
 - parameter request: the request HTTP object
 - parameter response: the response HTTP object
 */
func getLottery(request: HTTPRequest, response: HTTPResponse) {
    
    var lotteryObjects = [String]()
    if let cursorToCollection = collection.find() {
        for object in cursorToCollection {
            // Convert the BSON cursor to a JSON dictionary
            if
                let rawJSON = try? object.asString.jsonDecode(),
                var element = rawJSON as? [String: Any]
            {
                // Remove unwanted data
                element.remove(at: element.index(forKey: "_id")!)
                // Encode the element as String and send it.
                if let elementString = try? element.jsonEncodedString() {
                    lotteryObjects.append(elementString)
                }
            }
        }
    }
    
    reply(response: response, status: .ok, message: "[\(lotteryObjects.joined(separator: ","))]")
}

/**
 POST request handler
 
 - parameter request: the request HTTP object
 - parameter response: the response HTTP object
 */
func createLottery(request: HTTPRequest, response: HTTPResponse) {
    do {
        guard var json = try request.postBodyString?.jsonDecode() as? [String:Any] else {
            reply(response: response, status: .badRequest, message: "\"JSON couldn't be parsed\"")
            return
        }
        
        guard let bson = createLotteryBSON(json: json) else {
            reply(response: response, status: .badRequest,
                  message: "\"Failed creating lottery entry\"")
            return
        }
        
        defer {
            bson.close()
        }
        
        let insert = collection.insert(document: bson) as MongoResult
        let (message, statusCode) =
            parseMongoResult(result: insert, defaultAction: ("Faluire", .internalServerError))
        
        
        reply(response: response, status: statusCode, message: "\"\(message)\"")
        
    } catch {
        reply(response: response, status: .badRequest, message: "\"JSON couldn't be parsed\"")
        return
    }
}

/**
 PUT request handler
 
 - parameter request: the request HTTP object
 - parameter response: the response HTTP object
 */
func editLottery(request: HTTPRequest, response: HTTPResponse) {
    guard let timestamp = request.urlVariables["timestamp"] else {
        reply(response: response, status: .badRequest, message: "\"URI Variable is missing\"")
        return
    }
    
    do {
        guard let json = try request.postBodyString?.jsonDecode() as? [String:Any] else {
            reply(response: response, status: .badRequest, message: "\"JSON couldn't be parsed\"")
            return
        }
        
        guard
            let bson = createLotteryBSON(json: json),
            let id = json["timestamp"] as? String,
            let selectorBson = createPartialLotteryBSON(json: ["timestamp": timestamp]).0
            else {
                reply(response: response, status: .badRequest,
                      message: "\"Failed creating lottery entry\"")
                return
        }
    
        defer {
            bson.close()
            selectorBson.close()
        }
        
        let update = collection.update(selector: selectorBson, update: bson) as MongoResult
        let (message, statusCode) =
            parseMongoResult(result: update, defaultAction: ("Faluire", .internalServerError))

        reply(response: response, status: statusCode, message: "\"\(message)\"")
        
    } catch {
        reply(response: response, status: .badRequest, message: "\"JSON couldn't be parsed\"")
        return
    }
}

/**
 DELETE request handler
 
 - parameter request: the request HTTP object
 - parameter response: the response HTTP object
 */
func removeLottery(request: HTTPRequest, response: HTTPResponse) {
    guard let timestamp = request.urlVariables["timestamp"] else {
        reply(response: response, status: .badRequest, message: "\"URI Variable is missing\"")
        return
    }
    
    var bson = BSON()
    defer {
        bson.close()
    }
    bson.append(key: "timestamp", string: timestamp)
    
    
    // TODO delete the entry.
    // HINT Use the bson provided
    // NOTE: it is ok to assume that its only one entry since `timestamp` key is unique
    
    // TODO recall `parseMongoResult`. whats the right default action?
    
    let remove = collection.remove(selector: bson, flag: .singleRemove)
    let (message, statusCode) = parseMongoResult(result: remove,defaultAction: ("Success", .ok))
    
    reply(response: response, status: statusCode, message: "\"\(message)\"")
}



