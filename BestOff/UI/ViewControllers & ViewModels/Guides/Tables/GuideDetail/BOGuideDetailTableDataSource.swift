//
//  BOGuideDetailTableDataSource.swift
//  BestOff
//
//  Created by Ivar Johannesson on 15/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

class BOGuideDetailTableDataSource: NSObject, BOCategoryDetailListProtocol{
    
    
    var catItem = Observable<BOCatItem?>(nil)
    
    //RowHeights used in both types of tables
    let bigCellRowHeight:CGFloat = 310
    
    convenience init(catItem: BOCatItem){
        self.init()
        self.catItem.value = catItem
    }
    
    let topBigImgCellIndex = 0
    
    func setCatItemTo(item: BOCatItem) {
        self.catItem.value = item
    }
}

extension BOGuideDetailTableDataSource{

    func numberOfRows() -> Int {
        
        guard let item = self.catItem.value else { return 0 }
        guard let count = item.detailItem?.arrItems.count else { return 0}
        
        return count
    }

    func numberOfSections() -> Int {
        return 1
    }

    func cellForRowAtIndexPathIn(myTableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == topBigImgCellIndex{
            
            let topCell = myTableView.dequeueReusableCell(withIdentifier: TopGuideCell.reuseIdentifier()) as! TopGuideCell
            guard let item = catItem.value else { return UITableViewCell() }
            topCell.setupWith(item: item)
            return topCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRowAtIndexPathIn(myTableView: tableView, indexPath: indexPath)
    }
}

extension BOGuideDetailTableDataSource: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let bigImgTopCellIndex = 0
        let txtDescCell = 1
        // let txtDescCellHeight =
        
        if indexPath.row == bigImgTopCellIndex{
            return bigCellRowHeight
        }
        if indexPath.row == txtDescCell{
            
        }
        
        return 10
    }
}
