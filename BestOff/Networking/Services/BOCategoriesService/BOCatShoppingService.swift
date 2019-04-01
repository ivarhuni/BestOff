//
//  Service+Categories.swift
//  BestOff
//
//  Created by Ivar Johannesson on 05/03/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import SwiftyJSON

//typealias json = [String:Any]

//Categories
//GET
struct BOCatShoppingService{
    
    func getShopping(completionHandler: @escaping (_ result: [Any], _ error: Error?) -> Void){
        
        guard let url = URL(string: Endpoint.rvkShopping.path) else {
            completionHandler([], NetworkError.URLError)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            do {
                
                guard let jsonAsData = data else {
                    completionHandler([], NetworkError.dataError)
                    return
                }
                print(jsonAsData)
                let catShopping = try JSONDecoder().decode(BOCatShopping.self, from: jsonAsData)
                print(catShopping)
                
                
            }
            catch let jsonErr {
                completionHandler([], jsonErr)
            }
            }.resume()
    }
}

