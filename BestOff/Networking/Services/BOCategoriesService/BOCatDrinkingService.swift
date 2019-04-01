//
//  BOCatDrinkingService.swift
//  BestOff
//
//  Created by Ivar Johannesson on 01/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

struct BOCatDrinkingService{
    
    func getDrinks(completionHandler: @escaping (_ result: [Any], _ error: Error?) -> Void){
        
        guard let url = URL(string: Endpoint.rvkDrink.path) else {
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
                let catDrinks = try JSONDecoder().decode(BOCatDrinking.self, from: jsonAsData)
                print(catDrinks)
                
                
            }
            catch let jsonErr {
                completionHandler([], jsonErr)
            }
            }.resume()
    }
}
