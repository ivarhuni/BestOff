//
//  Service+Categories.swift
//  BestOff
//
//  Created by Ivar Johannesson on 05/03/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

struct BOCatShoppingService{
    
    func getShopping(completionHandler: @escaping (_ result: BOCatShopping?, _ error: Error?) -> Void){
        
        guard let url = URL(string: Endpoint.rvkShopping.path) else {
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
                var catShopping = try JSONDecoder().decode(BOCatShopping.self, from: jsonAsData)
                
                let arrDetailItems = catShopping.items.compactMap{ DetailItemFactory.createCategoryDetailFromText(categoryItemContentText: $0.contentText, strHTML: $0.contentHtml) }
                //catShopping.detailItems = arrDetailItems
                //completionHandler([BOCatShopping], nil)
                catShopping.detailItems = arrDetailItems
                completionHandler(catShopping, nil)
            }
            catch let jsonErr {
                completionHandler(nil, jsonErr)
            }
            }.resume()
    }
}
