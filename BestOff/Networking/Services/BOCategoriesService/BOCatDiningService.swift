//
//  BODiningService.swift
//  BestOff
//
//  Created by Ivar Johannesson on 01/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

struct BOCatDiningService{
    
    func getDiners(completionHandler: @escaping (_ result: BOCatDining?, _ error: Error?) -> Void){
        
        guard let url = URL(string: Endpoint.rvkDining.path) else {
            completionHandler(nil, NetworkError.URLError)
            return
        }
        print("Fetching URL " + url.absoluteString)
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            do {
                
                guard let jsonAsData = data else {
                    completionHandler(nil, NetworkError.dataError)
                    return
                }
                var catDiners = try JSONDecoder().decode(BOCatDining.self, from: jsonAsData)
                
                let arrDetailItems = catDiners.items.compactMap{ DetailItemFactory.createCategoryDetailFromText(categoryItemContentText: $0.contentText, strHTML: $0.contentHtml) }
                catDiners.detailItems = arrDetailItems
                completionHandler(catDiners, nil)
            }
            catch let jsonErr {
                completionHandler(nil, jsonErr)
            }
            }.resume()
    }
}
