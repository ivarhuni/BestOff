//
//  Endpoint.swift
//  BestOff
//
//  Created by Ivar Johannesson on 29/03/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

enum Endpoint {
    
    case rvkDrink
    case rvkActivities
    case rvkShopping
    case rvkDining
    
    case guides
    
    case events
    
    case north
    case east
    case westfjords
    case south
    case west
    case reykjanes
}

struct TestStruct{
    
    var name: String
}

extension  Endpoint{
    
    func getURLforType() -> URL?{
        
        switch self {
            
            
            
        case .rvkDrink:
            return URL(string: "https://grapevine.is/best-of-reykjavik/2019/drinking-2019/feed/json")
        case .rvkActivities:
            return URL(string: "https://grapevine.is/best-of-reykjavik/2019/activities-2019/feed/json")
        case .rvkShopping:
            return URL(string: "https://grapevine.is/best-of-reykjavik/2019/shopping-2019/feed/json")
        case .rvkDining:
            return URL(string: "https://grapevine.is/best-of-reykjavik/2019/dining-2019/feed/json")
        case .guides:
            return URL(string: "https://grapevine.is/best-of-reykjavik/guides/feed/json")
        case .north:
            return URL(string: "https://grapevine.is/best-of-iceland/north/feed/json")
        case .east:
            return URL(string: "https://grapevine.is/best-of-iceland/east/feed/json")
        case .south:
            return URL(string: "https://grapevine.is/best-of-iceland/south/feed/json")
        case .west:
            return URL(string: "https://grapevine.is/best-of-iceland/west/feed/json")
        case .reykjanes:
            return URL(string: "https://grapevine.is/best-of-iceland/reykjanes/feed/json")
        case .westfjords:
            return URL(string: "https://grapevine.is/best-of-iceland/reykjanes/feed/json")
        case .events:
            return URL(string: "https://appeningtoday.herokuapp.com/api")
        }
    }
    
    func isIcelandEndpoint() -> Bool{
        
        switch self {
        case .rvkDrink, .rvkDining, .rvkShopping, .rvkActivities, .events, .guides:
            return false
        default:
            return true
        }
    }
}
