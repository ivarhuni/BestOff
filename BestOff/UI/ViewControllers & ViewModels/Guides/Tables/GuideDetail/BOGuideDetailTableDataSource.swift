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
        return 1
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
