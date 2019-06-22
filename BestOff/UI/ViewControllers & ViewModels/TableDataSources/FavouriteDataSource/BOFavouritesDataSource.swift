//
//  BOFavouritesDataSource.swift
//  BestOff
//
//  Created by Ivar Johannesson on 28/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//


import Foundation
import UIKit
import Bond
import ReactiveKit

class BOFavouritesDataSource: NSObject{
    
    private let rowHeight:CGFloat = 176
    
    private let sectionCount = 1
    
    let arrFavourites = Observable<[BOCatItem]>([])
    
    weak var deleteDelegate: DeleteFavouriteItem?
    weak var editClickedDelegate: EditCellClicked?
    weak var catDetailDelegate: ShowCategoryDetailForType?
    
    let isDeleteActive = Observable<Bool>(false)
    
    override init(){
        do{
            let arrFavs = try FavouriteManager.getFavouriteItems()
            self.arrFavourites.value = arrFavs
        } catch{
            print(error)
            print("unable to fetch favs")
        }
    }
}


extension BOFavouritesDataSource: UITableViewDataSource{
    
    func cellForRowAtIndexPathIn(myTableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let dummyCell = UITableViewCell()
            dummyCell.selectionStyle = .none
            return dummyCell
        }
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: DoubleItemImgCell.reuseIdentifier()) as! DoubleItemImgCell
        
        let arrItems = getCatItemsForIndexPath(indexPath: indexPath)
        cell.setupWithArrCatItems(arrCatItems: arrItems, screenType: .rvkDining, isEditActive: self.isDeleteActive.value)
        cell.catDetailDelegate = self
        
        if isDeleteActive.value{
            cell.deleteDelegate = self
        }else{
            cell.deleteDelegate = nil
        }
        
        return cell
    }
    
    func getCatItemsForIndexPath(indexPath: IndexPath) -> [BOCatItem]{
        
        if indexPath.row == 0{ return [] }
        
        var indexLeft:Int = 0
        var indexRight:Int = 1
        
        if indexPath.row == 1 {
            
            guard let leftItem = arrFavourites.value[safe: indexLeft] else{
                return []
            }
            guard let rightItem = arrFavourites.value[safe: indexRight] else{
                return [leftItem]
            }
            
            return [leftItem, rightItem]
        }
        
        indexLeft = (indexPath.row * 2) - 2
        indexRight = (indexPath.row * 2) - 1
        
        guard let leftItem = arrFavourites.value[safe: indexLeft] else{
            return []
        }
        guard let rightItem = arrFavourites.value[safe: indexRight] else{
            return [leftItem]
        }
        
        return [leftItem, rightItem]
    }
    
    func getRowCount() -> Int{
        
        let dummyWhiteSpaceCellCount = 1
        var count = Double(arrFavourites.value.count) / 2.0
        count.round(.up)
        
        return Int(count) + dummyWhiteSpaceCellCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRowCount()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRowAtIndexPathIn(myTableView:tableView, indexPath:indexPath)
    }
}

extension BOFavouritesDataSource: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("pressed in fav")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //Dummy whitespace cell
        if indexPath.row == 0 { return Constants.dummyFavWhiteSpaceCellHeight }
        
        let normalCellHeightRatio:CGFloat = 176.0/375.0
        let normalCellHeight:CGFloat = (UIScreen.main.bounds.size.width * normalCellHeightRatio) + 20
        
        return normalCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        // This is where you would change section header content
        let headerCell = tableView.dequeueReusableCell(withIdentifier: BOFavHeaderCell.reuseIdentifier()) as! BOFavHeaderCell
        
        if arrFavourites.value.count == 0 {
            
            headerCell.setupWithNoItems()
            return headerCell
        }
        
        headerCell.setupWith(editEnabled: isDeleteActive.value, delegate: self)
        headerCell.isUserInteractionEnabled = true
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return Constants.editRowHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
}

extension BOFavouritesDataSource: DoubleCellClicked, ShowCategoryDetailForType{
    
    func didClick(item: BOCatItem) {
        
        guard let catDetail = item.detailItem else { print("not detail item in BOCatItem"); return}
        show(categoryDetail: catDetail, catItem: item, type: .rvkDrink)
    }
    
    
    func show(categoryDetail: BOCategoryDetail, catItem: BOCatItem, type: Endpoint) {
        guard let delegate = self.catDetailDelegate else{
            print("catdetaildelegate not set in favourites datasource")
            return
        }
        delegate.show(categoryDetail: categoryDetail, catItem: catItem, type: type)
    }
}

enum DeleteItem{
    
    case left
    case right
}

protocol DeleteFavouriteItem: class {
    
    func deleteClicked(deleteItemName: String)
}

extension BOFavouritesDataSource{
    
    func deleteItemWith(id: String){
        
        FavouriteManager.removeItemWith(strId: id)
    }
}

extension BOFavouritesDataSource: DeleteFavouriteItem{
    
    func deleteClicked(deleteItemName: String) {
        
        guard let delegate = deleteDelegate else {
            
            print("delete delegate not set for favourites data source")
            return
        }
        
        deleteItemWith(id: deleteItemName)
        
        //VC doesn't need to delete the item from the datasource, only update table
        delegate.deleteClicked(deleteItemName: "")
    }
}

extension BOFavouritesDataSource: EditCellClicked{
    
    func editClicked() {
        
        guard let editClickedDelegate = editClickedDelegate else {
            print("Edit Clicked Delegate not set in BOFavDataSource")
            return
        }
        editClickedDelegate.editClicked()
    }
}
