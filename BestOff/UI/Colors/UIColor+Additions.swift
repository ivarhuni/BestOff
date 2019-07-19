//
//  UIColor+Additions.swift
//  Reykjavík Grapevine
//
//  Generated on Zeplin. (30/04/2019).
//  Copyright (c) 2019 __MyCompanyName__. All rights reserved.
//

import UIKit

extension UIColor {

  @nonobjc class var colorRed: UIColor {
    return UIColor(red: 209.0 / 255.0, green: 65.0 / 255.0, blue: 68.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var colorBlackText: UIColor {
    return UIColor(white: 50.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var colorGreyDot: UIColor {
    return .gray
  }

  @nonobjc class var colorGreySep: UIColor {
    return UIColor(white: 200.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var colorGreyText: UIColor {
    return UIColor(white: 150.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var colorGreyBrowse: UIColor {
    return UIColor(white: 100.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var colorPeachBtnBorder: UIColor {
    return UIColor(red: 221.0 / 255.0, green: 129.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var colorYellowBtnBorder: UIColor {
    return UIColor(red: 212.0 / 255.0, green: 172.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var colorBlueBtnBorder: UIColor {
    return UIColor(red: 56.0 / 255.0, green: 167.0 / 255.0, blue: 181.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var colorWhite: UIColor {
    return UIColor(white: 1.0, alpha: 1.0)
  }

  @nonobjc class var colorBlack: UIColor {
    return UIColor(white: 0.0, alpha: 1.0)
  }
    
  @nonobjc class var colorGrayishBrown: UIColor {
    return UIColor(white: 75.0 / 255.0, alpha: 1.0)
  }
}

extension UIColor{
    
    static func colorForType(type: Endpoint) -> UIColor{
        
        switch type {
        case .rvkShopping, .south:
            return .colorYellowBtnBorder
        case .rvkDining, .north:
            return .colorRed
        case .rvkDrink, .east:
            return .colorPeachBtnBorder
        case .rvkActivities, .west:
            return .colorBlueBtnBorder
        case  .reykjanes:
            return .gray
        case .westfjords:
            return .blue
        default:
            return .colorRed
        }
    }
}

struct Constants{
    
    static let veryLowShadowOpacity: Float = 0.01
    static let lowShadowOpacity:Float = 0.05
    static let highShadowOpacity:Float = 0.1
    
    static let appHeaderCornerRadius:CGFloat = 10
    
    static let editRowHeight:CGFloat = 40
    static let dummyFavWhiteSpaceCellHeight:CGFloat = 1
    
    static let cornerRadiusGuideDetail:CGFloat = 13.0
}
