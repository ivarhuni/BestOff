//
//  BOHeaderViewModel.swift
//  BestOff
//
//  Created by Ivar Johannesson on 02/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

//protocol BOHeaderViewBtnProtocol {
//
//
//}

struct BOHeaderViewModel{
    
    let btnAlphaValue: CGFloat = 0.7
    
    
    let animatioShowHideDuration = 3.0
    let lblHideDuration = 0.2
    
    let isHamburgerActive = Observable<Bool>(true)
    let btnAnimationDuration:Double = 0.2
    var headerText = "BEST OF REYKJAVIK"
    
    let originalBtnWidthHeight:CGFloat = 25.0
    let xIconWidthHeight:CGFloat = 20.0
    
    let isDetailActive = Observable<Bool>(false)
    
    func didPressRightButton(){
        
        self.isHamburgerActive.value = !self.isHamburgerActive.value
    }
    
    
}
