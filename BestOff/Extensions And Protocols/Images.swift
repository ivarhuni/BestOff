//
//  File.swift
//  BestOff
//
//  Created by Ivar Johannesson on 02/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import UIKit

enum Asset: String{
    
    //MARK: UIImages from Asset
    case arrowGray = "ArrowGray"
    case bestOfIcon = "BestOfIcon"
    case deleteActive = "Delete-active"
    case delete = "Delete"
    case grapevineIcon = "Grapevine-icon"
    case hallgrimskirkja = "Hallgrimskirkja"
    case hamburger = "Hamburger"
    case heartFilled = "HeartFilled"
    case heart = "Heart"
    case Iceland = "Iceland"
    case locationIcon = "Location Icon"
    case mapIcon = "Map Icon"
    case xIcon = "X icon"
    
    var img: UIImage{
        return UIImage(asset: self)!
    }
}

extension UIImage {
    
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}

extension Asset: CaseIterable {}
