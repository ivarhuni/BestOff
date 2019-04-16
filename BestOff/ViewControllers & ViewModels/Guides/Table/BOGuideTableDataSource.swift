//
//  BOGuideTable.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit

class BOGuideTableDataSource: NSObject, BOTableDataSource {
    
    let arrItems: [BOCatItem]
    let tableView: UITableView
    let cellIdentifier = "guideCellIdentifier"
    
    required init(arrItems: [BOCatItem], tableView: UITableView){
        self.arrItems = arrItems
        self.tableView = tableView
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func item(at indexPath: IndexPath) -> BOCatItem {
        return arrItems[indexPath.row]
    }
    
    func numberOfRows() -> Int {
        return arrItems.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func cellForRowAtIndexPathIn(myTableView: UITableView, indexPath: IndexPath) -> BOGuideCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BOGuideCell else {
            let cell = BOGuideCell()
            cell.setup()
            return cell
        }
        cell.setup()
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
