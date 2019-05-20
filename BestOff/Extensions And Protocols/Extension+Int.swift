//
//  Extension+Int.swift
//  BestOff
//
//  Created by Ivar Johannesson on 20/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation


extension Int{
    
    func isEven() -> Bool{
        if self % 2 == 0 { return true }
        return false
    }
}
