//
//  NetworkRequest.swift
//  Lodur
//
//  Created by Gunnar Bjarki Bjornsson on 11/08/2017.
//  Copyright © 2017 stokkur. All rights reserved.
//

import Foundation
import Alamofire

/*
 * Contains the network request that is sent
 */
struct NetworkRequest {
    
    var url: String!
    var method: HTTPMethod!
    var params: JSON?
    var headers: headers?
}

extension NetworkRequest{
    
    init(url:String, method: HTTPMethod) {
        self.init(url: url, method: method, params: nil, headers: nil)
    }
    
    init(url:String, method: HTTPMethod, params: JSON) {
        self.init(url: url, method: method, params: params, headers: nil)
    }
    
    init(url:String, method: HTTPMethod, headers: headers) {
        self.init(url: url, method: method, params: nil, headers: headers)
    }
}


/*
 * All models that have networking responsiblity can conform to this protocol
 */
protocol JSONReturnable{
    
    func toJSON() -> JSON
}


//MARK: - JSON Init

/*
 * All models that have networking responsiblity can conform to this protocol
 */
protocol JSONInitable {
    init?(json: JSON)
}

extension JSONInitable{
    
    /*
     * Returns an array of models that conform to JSONInitable protocol
     */
    func arrayOfItems<T: JSONInitable> (_ modelArray: Array<Any>) -> [T]{
        
        var arrOfItems:[T] = []
        
        for item in modelArray{
            
            if let json = item as? JSON{
                
                if let model = T(json: json){
                    arrOfItems.append(model)
                }
            }
        }
        
        return arrOfItems
    }
}
