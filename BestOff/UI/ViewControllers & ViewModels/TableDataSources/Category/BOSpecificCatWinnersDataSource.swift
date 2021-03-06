//
//  BOCatWinnersDataSource.swift
//  BestOff
//
//  Created by Ivar Johannesson on 21/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import UIKit
import Bond
import ReactiveKit



class BOSpecificCatWinnersDataSource: NSObject{
    
    let category: BOCategoryModel
    let catTitle: String
    let arrDataCatItems = Observable<[BOCatItem]>([])
    weak var catDetailDelegate: ShowCategoryDetailForType?
    
    required init?(category: BOCategoryModel?, catTitle: String){
        guard let cat = category else { return nil }
        self.category = cat
        self.catTitle = catTitle
        
        arrDataCatItems.value = self.category.items.shuffled()
    }
}

extension BOSpecificCatWinnersDataSource: UITableViewDataSource{
    
    func getNumberOfRows() -> Int{
        
        if arrDataCatItems.value.isEmpty { return 0 }
        
        return (arrDataCatItems.value.count / 2) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 { return getFirstImgCellFor(tableView: tableView) }
        
        return getCellForItemAt(indexPath: indexPath, inTableView: tableView)
    }
    
    func getFirstImgCellFor(tableView: UITableView) -> UITableViewCell{
        
        guard let item = arrDataCatItems.value.first?.detailItem?.arrItems.first else {
            
            print("returning default cell in firstImgCell")
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BOBigCatImgCell.reuseIdentifier()) as! BOBigCatImgCell
        cell.setupWithItem(item: item, type: self.category.type)
        return cell
    }
    
    func getCellForItemAt(indexPath: IndexPath, inTableView: UITableView) -> UITableViewCell{
        
        let cell = inTableView.dequeueReusableCell(withIdentifier: DoubleItemImgCell.reuseIdentifier()) as! DoubleItemImgCell
        //cell.setupWithArrCatDetailItems(arrCatDetailItems: getItemsForIndexPath(indexPath: indexPath), screenType: category.type ?? .rvkDining)
        cell.setupWithArrCatItems(arrCatItems: getCatItemsForIndexPath(indexPath: indexPath), screenType: category.type ?? .rvkDining, type: .category)
        cell.delegateDoubleCellClicked = self
        return cell
    }
    
    func getCatItemsForIndexPath(indexPath: IndexPath) -> [BOCatItem]{
        
        if indexPath.row == 0{
            
            guard let item = arrDataCatItems.value.first else {
                return []
            }
            return [item]
        }
        
        let indexLeft = (indexPath.row * 2) - 1
        let indexRight = indexPath.row * 2
        
        guard let leftItem = arrDataCatItems.value[safe: indexLeft] else{
            return []
        }
        guard let rightItem = arrDataCatItems.value[safe: indexRight] else{
            return [leftItem]
        }
        
        return [leftItem, rightItem]
    }
    
    func getItemsForIndexPath(indexPath: IndexPath) -> [BOCategoryDetailItem] {
        
        if indexPath.row == 0{
            
            guard let item = arrDataCatItems.value.first?.detailItem?.arrItems.first else {
                return []
            }
            return [item]
        }
        
        guard let leftItem = arrDataCatItems.value[safe: indexPath.row]?.detailItem?.arrItems[safe: 0] else {
            return []
        }
        guard let rightItem = arrDataCatItems.value[safe: indexPath.row + 1]?.detailItem?.arrItems[safe: 0] else { return [leftItem] }
        return [leftItem, rightItem]
    }
}

extension BOSpecificCatWinnersDataSource: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getHeightForRowAt(indexPath: indexPath)
    }
}

extension BOSpecificCatWinnersDataSource: DoubleCellClicked{
    
    func didClick(item: BOCatItem) {
        
        guard let catDetail = item.detailItem else { print("not detail item in BOCatItem"); return}
        guard let catType = category.type else { print("type not set"); return }
        show(categoryDetail: catDetail, catItem: item, type: catType)
    }
}

extension BOSpecificCatWinnersDataSource: ShowCategoryDetailForType{
    
    func show(categoryDetail: BOCategoryDetail, catItem: BOCatItem, type: Endpoint) {
        catDetailDelegate?.show(categoryDetail: categoryDetail, catItem: catItem, type: type)
    }
    
    func didSelectAt(indexPath: IndexPath){
        indexPath.row == 0 ? didSelectTopItem() : print("did not select top item in BOSpecficiCatWinnersDataSource")
    }
    
    func didSelectTopItem(){
        guard let item = arrDataCatItems.value.first else {
            
            print("No top item to display")
            return
        }
        didSelectSelectWith(item: item)
    }
    
    func didSelectSelectWith(item: BOCatItem){
        print("selected item :")
        print(item.title)
        guard let catDetail = item.detailItem else{
            
            print("no detail item in BOCatItem")
            return
        }
        guard let catType = category.type else {
            
            print("no catType in categoryModel")
            return
        }
        show(categoryDetail: catDetail, catItem: item, type: catType)
    }
    
    func getHeightForRowAt(indexPath: IndexPath) -> CGFloat{
        
        let bigImgCellHeight:CGFloat = 207
        let normalCellHeightRatio:CGFloat = 176/375
        let normalCellHeight:CGFloat = (UIScreen.main.bounds.size.width * normalCellHeightRatio) + 20
        
        if indexPath.row == 0 { return bigImgCellHeight }
        
        return normalCellHeight
    }
}
