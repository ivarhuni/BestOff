//
//  EventHelper.swift
//  BestOff
//
//  Created by Ivar Johannesson on 27/06/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

struct EventHelper{
    
    static func createCatModelFromEventModel(events: [Event]) -> [BOCatItem] {
        
        var catItemArray: [BOCatItem] = []
        
        for event in events{
            
            let dummyAuthor = BOAuthor.init(avatar: "", name: event.venue, url: "")
            
            let catItem = BOCatItem.init(contentText: event.description, contentHtml: "", id: "", image: event.imgUrl, title: event.title, url: event.imgUrl, author: dummyAuthor)
            catItemArray.append(catItem)
        }
        return catItemArray
    }
}
