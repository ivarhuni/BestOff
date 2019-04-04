//
//  BOCatDrinkingService.swift
//  BestOff
//
//  Created by Ivar Johannesson on 01/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

struct BOCatDrinkingService{
    
    func getDrinks(completionHandler: @escaping (_ result: BOCatDrinking?, _ error: Error?) -> Void){
        
        guard let url = URL(string: Endpoint.rvkDrink.path) else {
            completionHandler(nil, NetworkError.URLError)
            return
        }
        print("Fetching URL" + url.absoluteString)
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            do {
                guard let jsonAsData = data else {
                    completionHandler(nil, NetworkError.dataError)
                    return
                }
                var catDrinks = try JSONDecoder().decode(BOCatDrinking.self, from: jsonAsData)
                let arrDetailItems = catDrinks.items.compactMap{ DetailItemFactory.createCategoryDetailFromText(categoryItemContentText: $0.contentText, strHTML: $0.contentHtml) }
                catDrinks.detailItems = arrDetailItems
                completionHandler(catDrinks, nil)
            }
            catch let jsonErr {
                completionHandler(nil, jsonErr)
            }
            }.resume()
    }
}
