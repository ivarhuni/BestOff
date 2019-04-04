//
//  BOGuideService.swift
//  BestOff
//
//  Created by Ivar Johannesson on 04/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

struct BOGuideService{
    
    func getGuides(completionHandler: @escaping (_ result: BOSuperGuide?, _ error: Error?) -> Void){
        
        guard let url = URL(string: Endpoint.guides.path) else {
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
                var superGuides = try JSONDecoder().decode(BOSuperGuide.self, from: jsonAsData)
                print()
                //let arrDetailItems = catShopping.items.compactMap{ DetailItemFactory.createCategoryDetailFromText(categoryItemContentText: $0.contentText, strHTML: $0.contentHtml) }
                //catShopping.detailItems = arrDetailItems
                //completionHandler([BOCatShopping], nil)
//                catShopping.detailItems = arrDetailItems
//                completionHandler(catShopping, nil)
            }
            catch let jsonErr {
                completionHandler(nil, jsonErr)
            }
            }.resume()
    }
}
