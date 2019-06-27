//
//  EventList.swift
//  BestOff
//
//  Created by Ivar Johannesson on 27/06/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

struct EventList{
    
    static let eventList = "events"
    var eventList: [Event] = []
}

extension EventList: JSONInitable{
    
    init?(json: JSON){
        
        if let events = json[EventList.eventList] as? Array<JSON>{
            
            self.eventList = events.flatMap{ Event(json: $0) }
        }
    }
}
