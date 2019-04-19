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

class BOGuideTableDataSource: NSObject, BOTableDataSourceProtocol {
    
    var categoryModel = Observable<BOCategoryModel?>(nil)
    
    convenience init(categoryModel: BOCategoryModel){
        self.init()
        self.categoryModel.value = categoryModel
    }
    
    func setDataModel(model: BOCategoryModel) {
        categoryModel.value = model
    }
    
    func item(at indexPath: IndexPath) -> BOCatItem? {
        guard let model = self.categoryModel.value else{
            return nil
        }
        return model.items[indexPath.row]
    }
    
    func numberOfRows() -> Int {
        
        guard let model = self.categoryModel.value else{
            return 0
        }
        print("arrItems Count: ")
        print(model.items.count)
        return model.items.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func cellForRowAtIndexPathIn(myTableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: BOGuideCell.reuseIdentifier()) as! BOGuideCell
        guard let myItem = item(at: indexPath) else{
            return UITableViewCell()
        }
        print("reusing cell")
        cell.setupWithGuide(myItem)
        return cell
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
