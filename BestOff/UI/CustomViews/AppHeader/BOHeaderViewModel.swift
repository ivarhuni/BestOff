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
    let isHamburgerActive = Observable<Bool>(true)
    let btnAnimationDuration:Double = 0.4
    var headerText = "BEST OF REYKJAVIK"
    
    func didPressRightButton(){
        
        self.isHamburgerActive.value = !self.isHamburgerActive.value
    }
    
    
}
