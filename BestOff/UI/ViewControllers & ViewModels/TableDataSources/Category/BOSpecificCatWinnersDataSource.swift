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
        cell.setupWithArrCatDetailItems(arrCatDetailItems: getItemsForIndexPath(indexPath: indexPath), screenType: category.type ?? .rvkDining)
        return cell
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

extension BOSpecificCatWinnersDataSource{
    
    func didSelectAt(indexPath: IndexPath){
        indexPath.row == 0 ? didSelectTopItem() : print("did not select top item in BOSpecficiCatWinnersDataSource")
    }
    
    func didSelectTopItem(){
        guard let topItem = self.category.items.first else { return }
        didSelectSelectWith(item: topItem)
    }
    
    func didSelectSelectWith(item: BOCatItem){
        print("selected item :")
        print(item.title)
    }
    
    func getHeightForRowAt(indexPath: IndexPath) -> CGFloat{
        
        let bigImgCellHeight:CGFloat = 207
        let normalCellHeightRatio:CGFloat = 176/375
        let normalCellHeight:CGFloat = (UIScreen.main.bounds.size.width * normalCellHeightRatio) + 20
        
        if indexPath.row == 0 { return bigImgCellHeight }
        
        return normalCellHeight
    }
}
