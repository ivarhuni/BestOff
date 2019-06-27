//
//  Event.swift
//  BestOff
//
//  Created by Ivar Johannesson on 27/06/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

struct Event{
    
    static let aboutKey = "about"
    static let addressKey = "address"
    static let imgKey = "img"
    static let dayKey = "day"
    static let latKey = "lat"
    static let lngKey = "lng"
    static let poweredKey = "powered"
    static let timeKey = "time"
    static let titleKey = "title"
    static let topEventKey = "topevent"
    static let venueKey = "venue"
    static let whatKey = "what"
    static let imgUrl = "img"
    
    public var description = ""
    public var address = ""
    public var day = ""
    public var lat = ""
    public var lng = ""
    public var powered = false
    public var time = ""
    public var title = ""
    public var isTopEvent = true
    public var venue = ""
    public var type = ""
    public var imgUrl = ""
    public var date: Date? = nil
}

extension Event: JSONInitable{
    
    init?(json: JSON) {
        
        //All keyes needed for an event except powered i guess
        guard let about = json[Event.aboutKey] as? String else{
            print("missing key ABOUT")
            return nil
        }
        
        guard let address = json[Event.addressKey] as? String else{
            print("missing key ADDRESS")
            return nil
        }
        
        guard let day = json[Event.dayKey] as? String else{
            print("missing key DAY")
            return nil
        }
        
        guard let time = json[Event.timeKey] as? String else{
            print("missing key TIME")
            return nil
        }
        
        guard let title = json[Event.titleKey] as? String else{
            print("missing key TITLE")
            return nil
        }
        
        guard let isTop = json[Event.topEventKey] as? Bool else{
            print("missing key ISTOPEVENT")
            return nil
        }
        
        guard let venue = json[Event.venueKey] as? String else{
            print("missing key VENUE")
            return nil
        }
        
        guard let type = json[Event.whatKey] as? String else{
            print("missing key TYPE")
            return nil
        }
        
        guard let imgUrl = json[Event.imgUrl] as? String else{
            print("missing key IMG")
            return nil
        }
        
        if let lat = json[Event.latKey] as? String{
            self.lat = lat
        }
        
        if let lon = json[Event.lngKey] as? String{
            self.lng = lon
        }
        
        self.description = about
        self.address = address
        self.day = day
        self.time = time
        self.title = title
        self.venue = venue
        self.type = type
        self.imgUrl = imgUrl
        self.isTopEvent = isTop
        
        let arrTime = self.time.components(separatedBy: ":")
        
        
        if arrTime.count == 2{
            let strHour = arrTime[0]
            let strMin = arrTime[1]
            
            guard let intHour = Int(strHour), let intMin = Int(strMin) else{
                return
            }
            
            
            if intHour >= 0 && intHour < 25 && intMin >= 0 && intMin < 60{
                
                let gregorian = Calendar(identifier: .gregorian)
                let now = Date()
                var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
                
                components.hour = intHour
                components.minute = intMin
                components.second = 0
                
                date = gregorian.date(from: components)!
            }
        }
    }
}
