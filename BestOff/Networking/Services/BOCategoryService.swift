//
//  CategoryService.swift
//  BestOff
//
//  Created by Ivar Johannesson on 15/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

struct BOCategoryService{
    
    func getCategory(_ category:  Endpoint, completionHandler: @escaping (_ result: BOCategoryModel?, _ error: Error?) -> Void){
        
        guard let categoryURL = category.getURLforType() else{
            completionHandler(nil, NetworkError.URLError)
            return
        }
        
        print("Fetching URL " + categoryURL.absoluteString)
        URLSession.shared.dataTask(with: categoryURL) { (data, response, err) in
            do {
                
                guard let jsonAsData = data else {
                    completionHandler(nil, NetworkError.dataError)
                    return
                }
                var categoryData = try JSONDecoder().decode(BOCategoryModel.self, from: jsonAsData)
                
                let arrDetailItems = categoryData.items.compactMap{ DetailItemFactory.createCategoryDetailFromText(categoryItemContentText: $0.contentText, strHTML: $0.contentHtml) }
                categoryData.detailItems = arrDetailItems
                completionHandler(categoryData, nil)
            }
            catch let jsonErr {
                completionHandler(nil, jsonErr)
            }
            }.resume()
        
    }
}
