//
//  EventService.swift
//  TODO
//
//  Created by Ivar Johannesson on 11/03/2018.
//  Copyright © 2018 Stokkur. All rights reserved.
//

import Foundation

class EventService: NetworkingService{
    
    public func getEvents(with result: @escaping (_ result: Result<EventList>) -> ()){
        
        let endpoint = "http://appeningtoday.herokuapp.com/api"
        
        let request = NetworkRequest(url: endpoint, method: .get)
        
        networking.request(request) { (json, error) in
            
            let resultWrapper:Result<EventList> = self.resultFromJSON(json, error)
            result(resultWrapper)
        }
    }
}
