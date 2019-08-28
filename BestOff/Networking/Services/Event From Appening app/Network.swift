//
//  Networking.swift
//  Lodur
//
//  Created by Gunnar Bjarki Bjornsson on 28/06/2017.
//  Copyright © 2017 stokkur. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

///JSON data is of type [String: Any]
typealias JSON = [String: Any]
///Headers are of type string:string
typealias headers = [String: String]?

final class Networking: NSObject {
    
    //MARK: - Properties
    static let manager = Networking()
    
    //the encoding used to send/Receive data
    private var encoding:ParameterEncoding = JSONEncoding.default
    
    //MARK: - Public methods
    public func request(_ request:NetworkRequest, completion: @escaping (_ result: JSON?, _ error: NetworkError?) -> Void) {
        
        guard let url = URL(string: request.url) else {
            completion(nil, NetworkError.unknown(HTTPStatusCode.badRequest))
            return
        }
        
        let method = request.method
        let params = request.params
        
        //get the default headers
        var allHeaders = baseHeaders(request: request)
        
        //append to the headers if needed based on the request
        if let headers = request.headers{
            headers!.forEach{ (key, value) in allHeaders[key] = value }
        }
        
        Alamofire.request(url, method: method!, parameters: params, encoding: JSONEncoding.default, headers:allHeaders).responseJSON { (response:DataResponse<Any>) in
            
            print(url)
            //get the status code
            //MARK : FIX
            //let statusCode = response.response?.statusCodeEnum
            let httpStatusCode = response.response?.statusCode ?? 404
            
            let statusCode = HTTPStatusCode(rawValue: httpStatusCode)
            //act on the response received
            switch response.result {
            case .success(let value):
                //try to get the json
                
                if let json = value as? JSON{
                    //check the status of the call
                    if statusCode?.isSuccess == false {
                        print(json)
                        completion(nil, NetworkError(json: json, statusCode: statusCode))
                        return
                    }
                    //respond with json data
                    completion(json, nil)
                }
                else{
                    
                    var dictValue = [String:Any]()
                    dictValue["response"] = value
                    
                    if let json = dictValue as? JSON{
                        if statusCode?.isSuccess == false {
                            print(json)
                            completion(nil, NetworkError(json: json, statusCode: statusCode))
                            return
                        }
                        //respond with json data
                        completion(json, nil)
                    }
                    else{
                        //something weird happened. Unkown error
                        completion(nil,NetworkError.unknown(statusCode))
                    }
                }
            case .failure(let error):
                print(error)
                //if the status is a success but we don't get a body which results in a failure handle that as a success
                if statusCode?.isSuccess == true {
                    completion(nil,nil)
                    return
                }
                //respond with the errors description
                completion(nil, NetworkError(error: error, statusCode: statusCode))
            }
        }
    }
}

extension Networking{
    
    fileprivate func baseHeaders(request: NetworkRequest) -> [String:String]{
        
        let baseHeaders:[String:String] = ["Content-Type" : "application/json"]
        return baseHeaders
    }
}
