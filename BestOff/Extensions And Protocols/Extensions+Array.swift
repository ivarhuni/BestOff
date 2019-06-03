//
//  Extensions+Array.swift
//  BestOff
//
//  Created by Ivar Johannesson on 21/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation


extension Array {
    func randomItem() -> Element? {
        if isEmpty {
            print("IS EMPTY")
            return nil
        }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
