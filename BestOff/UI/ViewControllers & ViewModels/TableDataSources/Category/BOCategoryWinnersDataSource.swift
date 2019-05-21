//
//  BOCategoryWinnersDataSource.swift
//  BestOff
//
//  Created by Ivar Johannesson on 21/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import UIKit
import ReactiveKit
import Bond

//MARK: Properties
class BOCategoryWinnersDataSource: NSObject{
    
    private let rowCount = 4
    private let sectionCount = 1
    private let rowHeight = 350
    
    private let cellWidthToHeightRatio = 375/350
    
}

//MARK: Setters - public
extension BOCategoryWinnersDataSource{
    
    func refreshWithDiningModel(catModel: BOCategoryModel){
        
    }
    
    func refreshWithDrinkingModel(catModel: BOCategoryModel){
        
    }
    
    func refreshWithActivitiesModel(catModel: BOCategoryModel){
        
    }
    
    func setShoppingModel(catModel: BOCategoryModel){
        
    }
}

//MARK: TableProtocol
extension BOCategoryWinnersDataSource: BOCategoryWinnerListProtocol{
    
    func numberOfRows() -> Int {
        return rowCount
    }
    
    func numberOfSections() -> Int {
        return sectionCount
    }
    
    func cellForRowAtIndexPathIn(myTableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRowAtIndexPathIn(myTableView:tableView, indexPath:indexPath)
    }
}

