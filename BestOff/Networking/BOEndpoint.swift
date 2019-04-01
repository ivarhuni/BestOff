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
    
    var path: String{
        
        switch self {
        case .rvkDrink: return "https://grapevine.is/best-of-reykjavik/2019/drinking-2019/feed/json"
        case .rvkActivities: return "https://grapevine.is/best-of-reykjavik/2019/activities-2019/feed/json"
        case .rvkShopping: return "https://grapevine.is/best-of-reykjavik/2019/shopping-2019/feed/json"
        case .rvkDining: return "https://grapevine.is/best-of-reykjavik/2019/dining-2019/feed/json"
        }
    }
}
