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
}

extension  Endpoint{
    
    func getURLforType() -> URL?{
        
        if self == .rvkDrink{
            return URL(string: "https://grapevine.is/best-of-reykjavik/2019/drinking-2019/feed/json")
        }
        if self == .rvkActivities{
            return URL(string: "https://grapevine.is/best-of-reykjavik/2019/activities-2019/feed/json")
        }
        if self == .rvkShopping{
            return URL(string: "https://grapevine.is/best-of-reykjavik/2019/shopping-2019/feed/json")
        }
        if self == .rvkDining{
            return URL(string: "https://grapevine.is/best-of-reykjavik/2019/dining-2019/feed/json")
        }
        if self == .guides{
            return URL(string: "https://grapevine.is/best-of-reykjavik/2019/guides-2019/feed/json")
        }
        return nil
    }
}
