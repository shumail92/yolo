//
//  RemoteConnectionHandler.swift
//  Lottery
//
//  Created by Samy El Deib on 17/04/2017.
//  Copyright © 2017 Samy. All rights reserved.
//

enum RemoteConnectionError: Error {
    case noDataReturned
}

import Foundation
import Alamofire

class RemoteConnectionHandler {
    private static let url = "http://localhost:8080/lottery"
    
    
    // MARK: - Public
    /*
     * GETs draws from the server.
     * All fetched draw are returned through the success callback.
     * If there occurred an error failure() gets called.
     */
    class func getDraws(success: @escaping ([Draws])->Void, failure: @escaping (Error)->Void) {
        
        //TODO implement a Alamofire GET-Request. The url is stored in url.
        //Hint: have a look at the API
        
        let request = Alamofire.request(url, method: .get)
            .validate()
            .responseJSON { (response) in
                
                switch response.result {
                case .success(_):
                    if let rawJSON = response.result.value {
                        let lotteries = Draws.jsonToDraws(rawJSON: rawJSON)
                        success(lotteries)
                    } else {
                        failure(RemoteConnectionError.noDataReturned)
                    }
                case .failure(let error):
                    failure(error)
                }
        }
        
        debugPrint("Sent request:\n\(request)")

    }
    
    // MARK: - Assignment
    /* TODO:
     *  - You want to add POST REST request for draws
     *  - Check AddEditViewController for the methods' signatures you might wish to use
     *  - You will need to specify the endpoints (look at the API)
     *    Additional info: Checkout SWAGGER for real project REST documentation
     */
    class func postDraws(draw: Draws, success: @escaping ()->Void,
                         failure: @escaping (Error)->Void) {
        //TODO implement a Alamofire POST-Request. The url is stored in url.
        
        Alamofire.request(url, method: .post,
                          parameters: draw.toJSON(), encoding: JSONEncoding.default)
        .validate()
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(_):
                    success()
                case .failure(let error):
                    failure(error)
                }
            })
    }
    
    /*
     *  - Edit Draws using the timestamp as endpoint
     */
    class func putDraws(draw: Draws, success: @escaping ()->Void,
                        failure: @escaping (Error)->Void) {
        let request = Alamofire.request(url+"/\(draw.timestamp)", method: .put, parameters: draw.toJSON(), encoding: JSONEncoding.default)
            .validate()
            .responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success(_):
                    success()
                case .failure(let error):
                    failure(error)
                }
            })
        
        debugPrint("Sent request: \(request)")
    }
    
    /*
     *  - Delete Draws using the timestamp as endpoint
     */
    class func deleteDraws(timestamp: String, success: @escaping ()->Void,
                           failure: @escaping (Error)->Void) {
        let request = Alamofire.request(url+"/\(timestamp)", method: .delete)
            .validate()
            .responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success(_):
                    success()
                case .failure(let error):
                    failure(error)
                }
            })
        
        debugPrint("Sent request: \(request)")
    }
}
