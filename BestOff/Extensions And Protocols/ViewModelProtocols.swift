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

protocol ViewModelDataSourceProtocol{
    var listDataSource: Observable<BOCategoryListDataSourceProtocol?> { get }
    var numberOfSections: Int { get }
}

protocol viewModelDetailSourceProtocol {
    var detailListDataSource: Observable<BOCatItem> { get }
}

protocol vmTableViewDelegate{
    func tableViewPressedAt(_ index: Int)
}
