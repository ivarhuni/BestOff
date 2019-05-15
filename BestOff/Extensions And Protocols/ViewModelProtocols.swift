//
//  ViewModelProtocol.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

protocol ViewModelErrorProtocol {
    
    var shouldShowError: Observable<Bool> { get }
    func showDataError()
    func hideDataError()
}

protocol ViewModelNetworkProtocol {
    func getCategoryFromJSON(type: Endpoint)
}

protocol ViewModelDataSourceProtocol{
    var dataSource: Observable<BOCategoryListDataSourceProtocol?> { get }
    var numberOfSections: Int { get }
}

protocol vmTableViewDelegate{
    
    func tableViewPressedAt(_ index: Int)
    static func getCellHeightAt(indexPath: IndexPath) -> CGFloat
}
