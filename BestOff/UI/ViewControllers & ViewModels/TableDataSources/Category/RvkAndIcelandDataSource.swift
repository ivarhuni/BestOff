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

enum LocationDataSource{
    
    case iceland
    case rvk
}

//MARK: Properties
class RvkAndIcelandDataSource: NSObject{
    
    private let diningIndex = 0
    private let drinkingIndex = 1
    private let shoppingIndex = 2
    private let activitiesIndex = 3

    private let locationType: LocationDataSource
    
    private let northIndex = 0
    private let eastIndex = 1
    private let southIndex = 2
    private let westIndex = 3
    private let westFjordsIndex = 4
    private let reykjanesIndex = 5
    
    private let rowCount: Int
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
    
    let north = Observable<BOCategoryModel?>(nil)
    private var randomNorthItem: BOCatItem?
    
    let east = Observable<BOCategoryModel?>(nil)
    private var randomEastItem: BOCatItem?

    let west = Observable<BOCategoryModel?>(nil)
    private var randomWestItem: BOCatItem?
    
    let south = Observable<BOCategoryModel?>(nil)
    private var randomSouthItem: BOCatItem?
    
    let westFjords = Observable<BOCategoryModel?>(nil)
    private var randomWestFjordItem: BOCatItem?
    
    let reykjanes = Observable<BOCategoryModel?>(nil)
    private var randomreykjanesItem: BOCatItem?
    
    
    weak var takeMeThereVMDelegate: TakeMeThereProtocol?
    weak var catDetailDelegate: ShowCategoryDetail?
    
    init(with locationDataSource: LocationDataSource){
        
        self.locationType = locationDataSource
        if locationDataSource == .iceland{
            rowCount = 6
            super.init()
            return
        }
        rowCount = 4
        super.init()
    }
}

extension RvkAndIcelandDataSource: TakeMeThereProtocol{
    
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
        case .guides:
            print("not applicable")
        case .north:
            takeMeThereVMDelegate?.didPressTakeMeThere(type: .north)
        case .east:
            takeMeThereVMDelegate?.didPressTakeMeThere(type: .east)
        case .westfjords:
            takeMeThereVMDelegate?.didPressTakeMeThere(type: .westfjords)
        case .south:
            takeMeThereVMDelegate?.didPressTakeMeThere(type: .south)
        case .west:
            takeMeThereVMDelegate?.didPressTakeMeThere(type: .west)
        case .reykjanes:
            takeMeThereVMDelegate?.didPressTakeMeThere(type: .reykjanes)
        }
    }
}

extension RvkAndIcelandDataSource: ShowCategoryDetail{
    
    func didPressCategoryDetail(catDetail: BOCategoryDetail, type: Endpoint?) {
        
        guard let delegate = catDetailDelegate else {
            print("delegate not set in ShowCategoryDetail RvkAndIcelandDataSource")
            return
        }
        delegate.didPressCategoryDetail(catDetail: catDetail, type: type)
    }
}

//MARK: TableProtocol
extension RvkAndIcelandDataSource: BOCategoryWinnerListProtocol{
    
    func numberOfRows() -> Int {
        return rowCount
    }
    
    func numberOfSections() -> Int {
        return sectionCount
    }
    
    func cellForRowAtIndexPathIn(myTableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: CategoryWinnerCell.reuseIdentifier()) as! CategoryWinnerCell
        cell.delegateShowCategoryDetail = self
        
        switch locationType {
        case .rvk:
            if indexPath.row == diningIndex{
                cell.setupWithCategory(category: dining.value, .rvkDining, randomItem: randomDiningItem, delegate: self)
                return cell
            }
            
            if indexPath.row == drinkingIndex{
                cell.setupWithCategory(category: drinking.value,  .rvkDrink, randomItem: randomDrinkingItem, delegate: self)
                return cell
            }
            
            if indexPath.row == activitiesIndex{
                cell.setupWithCategory(category: activities.value, .rvkActivities, randomItem: randomActivitiesItem, delegate: self)
                return cell
            }
            
            if indexPath.row == shoppingIndex{
                cell.setupWithCategory(category: shopping.value, .rvkShopping, randomItem: randomShoppingItem, delegate: self)
                return cell
            }
            
        case .iceland:
            
            if indexPath.row == northIndex{
                cell.setupWithCategory(category: north.value, .north, randomItem: randomNorthItem, delegate: self)
                return cell
            }
            if indexPath.row == eastIndex{
                cell.setupWithCategory(category: east.value, .east, randomItem: randomEastItem, delegate: self)
                return cell
            }
            if indexPath.row == westIndex{
                cell.setupWithCategory(category: west.value, .west, randomItem: randomWestItem, delegate: self)
                return cell
            }
            if indexPath.row == southIndex{
                cell.setupWithCategory(category: south.value, .south, randomItem: randomSouthItem, delegate: self)
                return cell
            }
            if indexPath.row == reykjanesIndex{
                cell.setupWithCategory(category: reykjanes.value, .reykjanes, randomItem: randomreykjanesItem, delegate: self)
                return cell
            }
            if indexPath.row == westFjordsIndex{
                cell.setupWithCategory(category: westFjords.value, .westfjords, randomItem: randomWestFjordItem, delegate: self)
                return cell
            }
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
    
    
    //
    func setCategoryModelAndRandomIdemForDataSourceType(catModel: BOCategoryModel, type: Endpoint){
        
        switch type {
        case .rvkDrink:
            self.drinking.value = catModel
            guard let randomItem = catModel.items.randomItem() else { return }
            randomDrinkingItem = randomItem
            
        case .rvkActivities:
            self.activities.value = catModel
            guard let randomItem = catModel.items.randomItem() else { return }
            randomActivitiesItem = randomItem
            
        case .rvkShopping:
            self.shopping.value = catModel
            guard let randomItem = catModel.items.randomItem() else { return }
            randomShoppingItem = randomItem
            
        case .rvkDining:
            self.dining.value = catModel
            guard let randomItem = catModel.items.randomItem() else { return }
            randomDiningItem = randomItem
            
        case .guides:
            print("not applicable")
            
        case .north:
            self.north.value = catModel
            guard let randomItem = catModel.items.randomItem() else { return }
            randomNorthItem = randomItem
            
        case .westfjords:
            self.westFjords.value = catModel
            guard let randomItem = catModel.items.randomItem() else { return }
            randomWestFjordItem = randomItem
            
        case .south:
            self.south.value = catModel
            guard let randomItem = catModel.items.randomItem() else { return }
            randomSouthItem = randomItem
            
        case .east:
            self.east.value = catModel
            guard let randomItem = catModel.items.randomItem() else { return }
            randomEastItem = randomItem
            
        case .west:
            self.west.value = catModel
            guard let randomItem = catModel.items.randomItem() else { return }
            randomWestItem = randomItem
            
        case .reykjanes:
            self.reykjanes.value = catModel
            guard let randomItem = catModel.items.randomItem() else { return }
            randomreykjanesItem = randomItem
        }
        
    }    
}
