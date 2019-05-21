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
    
    required init?(category: BOCategoryModel?, catTitle: String){
        guard let cat = category else { return nil }
        self.category = cat
        self.catTitle = catTitle
    }
}

extension BOSpecificCatWinnersDataSource: UITableViewDataSource{
    
    func getNumberOfRows() -> Int{
        
        return 1
//        if category.items.isEmpty { return 0 }
//        
//        return (category.items.count / 2) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 { return getFirstImgCellIn(tableView: tableView) }
        
        return getCellForItemAt(indexPath: indexPath)
    }
    
    func getFirstImgCellIn(tableView: UITableView) -> UITableViewCell{
        
        guard let item = self.category.items.first?.detailItem?.arrItems.first else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BOBigCatImgCell.reuseIdentifier()) as! BOBigCatImgCell
        cell.setupWithItem(item: item, category: self.category)
        return cell
    }
    
    func getCellForItemAt(indexPath: IndexPath) -> UITableViewCell{
        
        return UITableViewCell()
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
        
        let bigImgCellHeight:CGFloat = 346
        let normalCellHeight:CGFloat = 200
        
        if indexPath.row == 0 { return bigImgCellHeight }
        
        return normalCellHeight
    }
}
