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
extension BONetworkService{
    
    func getDining(){
    }
    
    func buildShoppingCategoryItemFromJson(json: Data) -> Void{
        
    }
    
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
                let catShopping = try JSONDecoder().decode(BOCatShop.self, from: jsonAsData)
                print(catShopping)
                
//                let json = try JSON(data: jsonResponse)
////                guard let items = json["items"].array else{
////                    completionHandler([], NetworkError.jsonParseError)
////                    return
////                }
//                let shoppingCategory = BOCatShopping.init(fromJson: json)
//                print(shoppingCategory)
                
                
            }
            catch let jsonErr {
                completionHandler([], jsonErr)
            }
            }.resume()
    }
    
    func getActivities(completionHandler: @escaping (_ result: [Any], _ error: Error?) -> Void){
        
    }
    
    func getDrinking(completionHandler: @escaping (_ result: [Any], _ error: Error?) -> Void){
        
    }
}


fileprivate extension Endpoint{
    
    var path: String{
        
        switch self {
        case .rvkDrink: return "https://grapevine.is/best-of-reykjavik/2019/drinking-2019/feed/json"
        case .rvkActivities: return "https://grapevine.is/best-of-reykjavik/2019/activities-2019/feed/json"
        case .rvkShopping: return "https://grapevine.is/best-of-reykjavik/2019/shopping-2019/feed/json"
        case .rvkDining: return "https://grapevine.is/best-of-reykjavik/2019/dining-2019"
        }
    }
}

