//
//  BOTableProtocol.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import UIKit

//Tableviews conform to these protocols to enforce consistency
protocol BOTableDataSource : class{
    var arrItems: [BOCatItem] { get }
    init(arrItems: [BOCatItem], tableView: UITableView)
    func item(at indexPath: IndexPath) -> BOCatItem
    func numberOfRows() -> Int
    func numberOfSections() -> Int
    func cellForRowAtIndexPathIn(myTableView: UITableView, indexPath: IndexPath) -> BOGuideCell
}

protocol BOTableDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}
