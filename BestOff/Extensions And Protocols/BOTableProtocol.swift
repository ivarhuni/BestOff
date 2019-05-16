//
//  BOTableProtocol.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import UIKit
import ReactiveKit
import Bond



//Tableviews conform to these protocols to enforce consistency
protocol BOCategoryListDataSourceProtocol: UITableViewDataSource, UITableViewDelegate{
    
    var categoryModel: Observable<BOCategoryModel?> { get }
    
    var tableDelegate: didPressListAtIndexDelegate? { get set }
    
    func setDataModel(model: BOCategoryModel)
    func items(at indexPath: IndexPath) -> [BOCatItem]
    func numberOfRows() -> Int
    func numberOfSections() -> Int
    func cellForRowAtIndexPathIn(myTableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}

protocol BOCategoryDetailListProtocol: UITableViewDataSource, UITableViewDelegate {
    
    var catItem: Observable<BOCatItem?> { get }
    func setCatItemTo(item: BOCatItem)
    func numberOfRows() -> Int
    func numberOfSections() -> Int
    func cellForRowAtIndexPathIn(myTableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}


protocol BOTableDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}
