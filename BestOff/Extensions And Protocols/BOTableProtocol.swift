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
    
    var tableDelegate: didPressListDelegate? { get set }
    
    func setDataModel(model: BOCategoryModel)
    func items(at indexPath: IndexPath) -> [BOCatItem]
    func numberOfRows() -> Int
    func numberOfSections() -> Int
    func cellForRowAtIndexPathIn(myTableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}

protocol BOCategoryWinnerListProtocol: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfRows() -> Int
    func numberOfSections() -> Int
    func cellForRowAtIndexPathIn(myTableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func setDiningModel(catModel: BOCategoryModel)
    func setDrinkingModel(catModel: BOCategoryModel)
    func setActivitiesModel(catModel: BOCategoryModel)
    func setShoppingModel(catModel: BOCategoryModel)
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
