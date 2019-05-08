//
//  BOMenuViewModel.swift
//  BestOff
//
//  Created by Ivar Johannesson on 08/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

enum ScreenType{
    case reykjavik
    case iceland
    case favourites
}

struct BOMenuViewModel{
    
    let selectedScreenType = Observable<ScreenType>(.reykjavik)
    
    init(withSelectedScreen: ScreenType){
        
    }
    
    func select(screen: ScreenType){
        
    }
}
