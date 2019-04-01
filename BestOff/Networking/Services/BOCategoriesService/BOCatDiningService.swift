//
//  BODiningService.swift
//  BestOff
//
//  Created by Ivar Johannesson on 01/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

struct BOCatDiningService{
    
    func getDiners(completionHandler: @escaping (_ result: [Any], _ error: Error?) -> Void){
        
        guard let url = URL(string: Endpoint.rvkDining.path) else {
            completionHandler([], NetworkError.URLError)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            do {
                
                guard let jsonAsData = data else {
                    completionHandler([], NetworkError.dataError)
                    return
                }
                let catDiners = try JSONDecoder().decode(BOCatDining.self, from: jsonAsData)
            }
            catch let jsonErr {
                completionHandler([], jsonErr)
            }
            }.resume()
    }
}
