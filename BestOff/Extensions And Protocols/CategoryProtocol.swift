//
//  CategoryProtocol.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

protocol CategoryItemProtocol{
    
    var arrCategory: Observable<[BOCategoryModel]> { get }
    func getCategoryItems() -> [BOCatItem]
    func getCategory() -> BOCategoryModel?
}
