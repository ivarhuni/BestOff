//
//  BOCatActivitiesService.swift
//  BestOff
//
//  Created by Ivar Johannesson on 01/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

struct BOCatActivitiesService{
    
    func getActivities(completionHandler: @escaping (_ result: BOCatActivities?, _ error: Error?) -> Void){
        
        guard let url = URL(string: Endpoint.rvkActivities.path) else {
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
                var catActivities = try JSONDecoder().decode(BOCatActivities.self, from: jsonAsData)
                
                let arrDetailItems = catActivities.items.compactMap{ DetailItemFactory.createCategoryDetailFromText(categoryItemContentText: $0.contentText, strHTML: $0.contentHtml) }
                catActivities.detailItems = arrDetailItems
                completionHandler(catActivities, nil)
            }
            catch let jsonErr {
                completionHandler(nil, jsonErr)
            }
            }.resume()
    }
}
