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
class RvkCategoriesDataSource: NSObject{
    
    private let diningIndex = 0
    private let drinkingIndex = 1
    private let shoppingIndex = 2
    private let activitiesIndex = 3
    
    private let rowCount = 4
    private let sectionCount = 1
    private let rowHeight:CGFloat = 350
    
    private let cellWidthToHeightRatio = 375/350
    
    let dining = Observable<BOCategoryModel?>(nil)
    private var randomDiningItem: BOCatItem?
    
    let drinking = Observable<BOCategoryModel?>(nil)
    private var randomDrinkingItem: BOCatItem?
    
    let activities = Observable<BOCategoryModel?>(nil)
    private var randomActivitiesItem: BOCatItem?
    
    let shopping = Observable<BOCategoryModel?>(nil)
    private var randomShoppingItem: BOCatItem?
    
    weak var takeMeThereVMDelegate: TakeMeThereProtocol?
}

extension RvkCategoriesDataSource: TakeMeThereProtocol{
    
    func didPressTakeMeThere(type: Endpoint) {
        
        switch type {
        case .rvkDining:
            takeMeThereVMDelegate?.didPressTakeMeThere(type: .rvkDining)
        case .rvkDrink:
            takeMeThereVMDelegate?.didPressTakeMeThere(type: .rvkDrink)
        case .rvkShopping:
            takeMeThereVMDelegate?.didPressTakeMeThere(type: .rvkShopping)
        case .rvkActivities:
            takeMeThereVMDelegate?.didPressTakeMeThere(type: .rvkActivities)
        default:
            print("default didpresstakemethere")
        }
    }
}

//MARK: TableProtocol
extension RvkCategoriesDataSource: BOCategoryWinnerListProtocol{
    
    func numberOfRows() -> Int {
        return rowCount
    }
    
    func numberOfSections() -> Int {
        return sectionCount
    }
    
    func cellForRowAtIndexPathIn(myTableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: CategoryWinnerCell.reuseIdentifier()) as! CategoryWinnerCell

        if indexPath.row == diningIndex{
            cell.setupWithCategory(category: dining.value, .rvkDining, randomItem: randomDiningItem)
            cell.delegateTakeMeThere = self
            return cell
        }
        
        if indexPath.row == drinkingIndex{
            cell.setupWithCategory(category: drinking.value,  .rvkDrink, randomItem: randomDrinkingItem)
            cell.delegateTakeMeThere = self
            return cell
        }
        
        if indexPath.row == activitiesIndex{
            cell.setupWithCategory(category: activities.value, .rvkActivities, randomItem: randomActivitiesItem)
            cell.delegateTakeMeThere = self
            return cell
        }
        
        if indexPath.row == shoppingIndex{
            cell.setupWithCategory(category: shopping.value, .rvkShopping, randomItem: randomShoppingItem)
            cell.delegateTakeMeThere = self
            return cell
        }
        
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

extension RvkCategoriesDataSource{
    
    func setDiningModel(catModel: BOCategoryModel){
        self.dining.value = catModel
        
        guard let randomItem = catModel.items.randomItem() else { return }
        randomDiningItem = randomItem
    }
    
    func setDrinkingModel(catModel: BOCategoryModel){
        self.drinking.value = catModel
        
        guard let randomItem = catModel.items.randomItem() else { return }
        randomDrinkingItem = randomItem
    }
    
    func setActivitiesModel(catModel: BOCategoryModel){
        self.activities.value = catModel
        
        guard let randomItem = catModel.items.randomItem() else { return }
        randomActivitiesItem = randomItem
    }
    
    func setShoppingModel(catModel: BOCategoryModel){
        self.shopping.value = catModel
        
        guard let randomItem = catModel.items.randomItem() else { return }
        randomShoppingItem = randomItem
    }
}

