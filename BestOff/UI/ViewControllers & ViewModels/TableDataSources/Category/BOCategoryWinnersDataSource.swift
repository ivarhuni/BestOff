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
    
    private let diningIndex = 0
    private let drinkingIndex = 1
    private let shoppingIndex = 2
    private let activitiesIndex = 3
    
    private let rowCount = 4
    private let sectionCount = 1
    private let rowHeight:CGFloat = 350
    
    private let cellWidthToHeightRatio = 375/350
    
    private let dining = Observable<BOCategoryModel?>(nil)
    private let drinking = Observable<BOCategoryModel?>(nil)
    private let activities = Observable<BOCategoryModel?>(nil)
    private let shopping = Observable<BOCategoryModel?>(nil)
}

//MARK: Setters - public
extension BOCategoryWinnersDataSource{
    
    func setDiningModel(catModel: BOCategoryModel){
        self.dining.value = catModel
    }
    
    func setDrinkingModel(catModel: BOCategoryModel){
        self.drinking.value = catModel
    }
    
    func setActivitiesModel(catModel: BOCategoryModel){
        self.activities.value = catModel
    }
    
    func setShoppingModel(catModel: BOCategoryModel){
        self.shopping.value = catModel
    }
}

extension BOCategoryWinnersDataSource{
    
    func getCellForDining() -> UITableViewCell{
        
        return UITableViewCell()
    }
    
    func getCellForDrinking() -> UITableViewCell{
        return UITableViewCell()
    }
    
    func getCellForShopping() -> UITableViewCell{
        return UITableViewCell()
    }
    
    func getCellForActivities() -> UITableViewCell{
        return UITableViewCell()
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
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: CategoryWinnerCell.reuseIdentifier()) as! CategoryWinnerCell
        
        cell.setupWithCategory()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRowAtIndexPathIn(myTableView:tableView, indexPath:indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}

