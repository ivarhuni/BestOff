//
//  NetworkError.swift
//  Lodur
//
//  Created by Gunnar Bjarki Bjornsson on 11/08/2017.
//  Copyright © 2017 stokkur. All rights reserved.
//

import Foundation


enum NetworkError: Error {
    case noInternet
    case custom(String,HTTPStatusCode?)
    case unknown(HTTPStatusCode?)
}


extension NetworkError: LocalizedError {
    
    ///Return the error description
    var why: String {
        switch self {
        case .noInternet:
            return "No Internet connection"
        case .unknown(let statusCode):
            return "Something went wrong. Sorry!" + " (\(statusCode!.rawValue))"
        case .custom(let message, _):
            return message
        }
    }
    
    var code:HTTPStatusCode{
        switch self {
        case .noInternet:
            return HTTPStatusCode.requestTimeout
        case .unknown(let statusCode):
            return statusCode!
        case .custom(_, let statusCode):
            return statusCode!
        }
    }
    
    ///Construct the error message from json
    init(json: JSON, statusCode: HTTPStatusCode?) {
        
        //let message = Session.manager.appLanguage().stringFor(json)
        let message = "someMsg"
        self = .custom(message, statusCode)
    }
    
    
    ///Construct the error message from json
    init(error: Error, statusCode: HTTPStatusCode?) {
        
        
        self = .custom("custom error", statusCode)
    }
}
