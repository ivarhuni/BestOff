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
    case events
}

struct BOMenuViewModel{
    
    let selectedScreenType = Observable<ContentType>(.reykjavik)
    
    //Instead of selectedScreenType
    let screenType = Observable<ScreenType>(.reykjavik)
    
    let leadingConstantOff: CGFloat = -5.0
    let leadingConstantOn: CGFloat = 0.0
    let leadingImgConstantOn: CGFloat = 25.0
    let leadingImgConstantOff: CGFloat = 20
    let leadingLblConstantOff: CGFloat = 66
    let leadingLblConstantOn: CGFloat = 71
    
    let animationDuration = 0.25
    
    init(withSelectedScreen type: ContentType){
        selectedScreenType.value = type
    }
    
    private func selectFromMenuScreen(screenType: ScreenType){
        
        self.screenType.value = screenType
    }
    
    //This is a bug and needs to be set to ScreenType not contentType
    func select(screenType: ContentType){
        
        if screenType == self.selectedScreenType.value { return }
        
        selectedScreenType.value = screenType
    }
    
}
