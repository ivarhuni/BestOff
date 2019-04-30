//
//  ShowsErrorProtocol.swift
//  BestOff
//
//  Created by Ivar Johannesson on 29/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

protocol ShowsErrorProtocol: class {
    
    func presentErrorState() -> (() -> (Bool))
}
