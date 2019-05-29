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
    
    
    let arrFavDining = Observable<[BOCategoryDetailItem]>([])
    let arrFavDrinking = Observable<[BOCategoryDetailItem]>([])
    let arrFavActivities = Observable<[BOCategoryDetailItem]>([])
    let arrFavShopping = Observable<[BOCategoryDetailItem]>([])
    
    let arrFavourites = Observable<[BOCategoryDetailItem]>([])
    
    private let diningSectionIndex = 0
    private let drinkingSectionIndex = 1
    private let shoppingSectionIndex = 2
    private let activitySectionIndex = 3
    
    weak var deleteDelegate: DeleteFavouriteItem?
    weak var editClickedDelegate: EditCellClicked?
    
    let isDeleteActive = Observable<Bool>(false)
    
    
    override init(){
        
        super.init()
        //MOCK
        let burgerURL = "https://www.iheartnaptime.net/wp-content/uploads/2018/05/hamburger-recipe-1200x960.jpg"
        let firstDetailItem = BOCategoryDetailItem.init(itemName: "First", itemAddress: "First Address", itemDescription: "SomeReallyLong Desc", imageURL: burgerURL)
        let secondDetailItem = BOCategoryDetailItem.init(itemName: "Second Item", itemAddress: "First Address", itemDescription: "SomeReallyLong Desc", imageURL: burgerURL)
        let thirdItem = BOCategoryDetailItem.init(itemName: "Third Item Long Name", itemAddress: "First Address", itemDescription: "SomeReallyLong Desc", imageURL: burgerURL)
        let forthItem = BOCategoryDetailItem.init(itemName: "4 Item Long Name :) Because why not", itemAddress: "First Address", itemDescription: "SomeReallyLong Desc", imageURL: burgerURL)
        
        arrFavDining.value.append(firstDetailItem)
        arrFavDining.value.append(secondDetailItem)
        arrFavDining.value.append(thirdItem)
        arrFavDining.value.append(forthItem)
        
        arrFavDrinking.value.append(firstDetailItem)
        arrFavDrinking.value.append(secondDetailItem)
        arrFavDrinking.value.append(thirdItem)
        arrFavDrinking.value.append(forthItem)
        
        arrFavShopping.value.append(firstDetailItem)
        arrFavShopping.value.append(secondDetailItem)
        arrFavShopping.value.append(thirdItem)
        arrFavShopping.value.append(forthItem)
        
        arrFavActivities.value.append(firstDetailItem)
        arrFavActivities.value.append(secondDetailItem)
        arrFavActivities.value.append(thirdItem)
        arrFavActivities.value.append(forthItem)
        
        arrFavourites.value.append(contentsOf: arrFavDining.value)
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
        
        let arrItems = getItemsForIndexPath(indexPath: indexPath)
        cell.setupWithArrCatDetailItems(arrCatDetailItems: arrItems, screenType: .rvkDining)
        return cell
    }
    
    func getItemsForIndexPath(indexPath: IndexPath) -> [BOCategoryDetailItem] {

        guard let leftItem = arrFavourites.value[safe: indexPath.row - 1] else {
            return []
        }
        
        guard let rightItem = arrFavourites.value[safe: indexPath.row] else { return [leftItem] }
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
        
        let normalCellHeightRatio:CGFloat = 176/375
        let normalCellHeight:CGFloat = (UIScreen.main.bounds.size.width * normalCellHeightRatio) + 20
        
        return normalCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        // This is where you would change section header content
        let headerCell = tableView.dequeueReusableCell(withIdentifier: BOFavHeaderCell.reuseIdentifier()) as! BOFavHeaderCell
        headerCell.setupWith(editEnabled: isDeleteActive.value, delegate: self)
        headerCell.isUserInteractionEnabled = true
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return Constants.editRowHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "title"
    }
}

protocol DeleteFavouriteItem: class {
    
    func deleteClicked()
}

extension BOFavouritesDataSource{
    
    func deleteItemAt(indexPath: IndexPath){
        
        arrFavourites.value.remove(at: indexPath.row)
        
        deleteClicked()
    }
}

extension BOFavouritesDataSource: DeleteFavouriteItem{
    
    func deleteClicked() {
        
        guard let delegate = deleteDelegate else {
            
            print("delete delegate not set for favourites data source")
            return
        }
        delegate.deleteClicked()
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
