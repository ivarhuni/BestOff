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

struct BOHeaderViewModel{
    
    let animationDuration = 3.0
    let btnAlphaValue: CGFloat = 0.7
    
    static func getImageForButtonState(button: UIButton) -> UIImage{
        if button.state != .normal{
            return Asset.xIcon.img
        }
        return Asset.hamburger.img
    }
}
