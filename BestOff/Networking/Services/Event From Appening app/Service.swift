//
//  Service.swift
//  BestOff
//
//  Created by Ivar Johannesson on 27/06/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

typealias Result<T> = (model: T?,  message: String,  success: Bool, code: HTTPStatusCode?)

class NetworkingService {
    
    //MARK: - Properties
    
    public let networking = Networking.manager
    
    //MARK: - Private methods
    
    /*
     * Construct the model, message and result status from the json/error with generics
     */
    public func resultFromJSON<T: JSONInitable>(_ json: JSON?, _ error: NetworkErrors?) -> Result<T>{
        
        //If we have an error we return immediately with the errors message
        if let error = error {
            return Result(nil, error.why, false, error.code)
        }
            
            //else if we have some data we try to init the model with the data
        else if let json = json{
            
            if let model = T(json:json){
                return Result(model, "", true, HTTPStatusCode.ok)
            }
            else{
                return Result(nil, "Download Error", false, nil)
            }
        }
            //else we have an empty response but we take that as a success
        else{
            return Result(nil, "", true, HTTPStatusCode.ok)
        }
    }
}
