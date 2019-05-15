//
//  BOGuideTable.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond

class BOGuideTableDataSource: NSObject, BOCategoryListDataSourceProtocol {
    
    var categoryModel = Observable<BOCategoryModel?>(nil)
    
    let headerCellIndexRow = 0
    let BigCellIndexRow = 1
    let firstSplitCellIndexRow = 2
    
    let indexRowCountThreshold = 3
    
    
    convenience init(categoryModel: BOCategoryModel){
        self.init()
        self.categoryModel.value = categoryModel
    }
    
    func setDataModel(model: BOCategoryModel) {
        categoryModel.value = model
    }
}

extension BOGuideTableDataSource{
    
    
    //count = 0, noR = 1 (CatHeaderCell)
    
    //c = 1, noR = 2 (CatHeaderCell + BigCell)
    //c = 2, noR = 3 (CatHeaderCell + BigCell + smallCell)
    //c = 3, noR = 3 (CatHeaderCell + BigCell + 2 x doubleItemCell)
    //c = 4, noR = 4 (CatHeaderCell + BigCell + 3 x doubleItemCell)
    //c = 5, noR = 4 (CatHeaderCell + BigCell + 3 x doubleItemCell)
    //c = 6, nOR = 5 (CatHeaderCell + BigCell + 4 x doubleItemCell)
    //...
    //N > 3, c = n, noR = n, n is even
    //N > 3, c = n, noR = n-1, n is odd
    
    func items(at indexPath: IndexPath) -> [BOCatItem] {
        
        guard let model = self.categoryModel.value else{
            return []
        }
        
//        if indexPath.row > indexRowCountThreshold{
//            if indexPath.row % 2 == 0 { return model.items[indexPath.row-2]}
//        }
        
        if indexPath.row == headerCellIndexRow { return [] }
        if indexPath.row == BigCellIndexRow {
            guard let bigItem = model.items[safe: 0] else {
                print("no big item")
                return []
            }
            return [bigItem]
        }
        if indexPath.row == BigCellIndexRow + 1 {
            
            guard let leftItem = model.items[safe: 1] else {
                print("no right item bigcellIndexRow + 1 BOGUIDETABLEDATASOURCE")
                return []
            }
            guard let rightItem = model.items[safe: 2] else {
                print("no Right Item bigCellindexRow + 1 BOGUIDETABLEDATASOURCE")
                return [leftItem]
            }
            return [ leftItem, rightItem ]
        }
        
        guard let leftItem = model.items[safe: indexPath.row] else {
            
            print("no left item  >= 3   BOGUIDETABLEDATASOURCE")
            return []
        }
        guard let rightItem = model.items[safe: indexPath.row + 2] else {
            
            print("no right item >= 3 BOGUIDETABLEDATASOURCE")
            return [leftItem]
        }

        return [leftItem, rightItem]
    }
    
    func numberOfRows() -> Int {
        
        guard let model = self.categoryModel.value else{
            return 0
        }
        
        if model.items.count == 0 { return 1 }
        if model.items.count == 1 { return 2 }
        
        if model.items.count == 2 { return 3 }
        if model.items.count == 3 { return 3 }
       
        return model.items.count  - 2
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func cellForRowAtIndexPathIn(myTableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == headerCellIndexRow{
            let headerCell = myTableView.dequeueReusableCell(withIdentifier: BOCatHeaderCell.reuseIdentifier()) as! BOCatHeaderCell
            headerCell.setup()
            return headerCell
        }
        
        if indexPath.row == BigCellIndexRow {
            
            guard let bigCellItem = categoryModel.value?.items[safe: 0] else { return UITableViewCell() }
            let topCell = myTableView.dequeueReusableCell(withIdentifier: TopGuideCell.reuseIdentifier()) as! TopGuideCell
            topCell.setupWith(item: bigCellItem)
            return topCell
        }
        
        let arrItems = items(at: indexPath)
        let doubleItemCell = myTableView.dequeueReusableCell(withIdentifier: DoubleItemCell.reuseIdentifier()) as! DoubleItemCell
        doubleItemCell.setupWithItems(arrItems: arrItems)
        return doubleItemCell
    }
}

extension BOGuideTableDataSource: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.cellForRowAtIndexPathIn(myTableView: tableView, indexPath: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections()
    }
}

extension Int{
    
    func isEven() -> Bool{
        if self % 2 == 0 { return true }
        return false
    }
}
