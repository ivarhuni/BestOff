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
    
    private let rowHeight:CGFloat = 60
    
    let arrFavDining = Observable<[BOCategoryDetailItem]>([])
    let arrFavDrinking = Observable<[BOCategoryDetailItem]>([])
    let arrFavActivities = Observable<[BOCategoryDetailItem]>([])
    let arrFavShopping = Observable<[BOCategoryDetailItem]>([])
    
    let diningSectionIndex = 0
    let drinkingSectionIndex = 1
    let shoppingSectionIndex = 2
    let activitySectionIndex = 3
    
    
    let isDeleteActive = Observable<Bool>(false)
    
    
    init(with diningItems: [BOCategoryDetailItem], drinkingItems: [BOCategoryDetailItem], activityItems: [BOCategoryDetailItem], shoppingItems: [BOCategoryDetailItem]){
        
        arrFavDining.value = diningItems
        arrFavDrinking.value = drinkingItems
        arrFavShopping.value = shoppingItems
        arrFavActivities.value = activityItems
        
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
        
        arrFavShopping.value.append(firstDetailItem)
        arrFavShopping.value.append(secondDetailItem)
        arrFavShopping.value.append(thirdItem)
        arrFavShopping.value.append(forthItem)
    }
}

extension BOFavouritesDataSource: UITableViewDataSource{
    
    
    func cellForRowAtIndexPathIn(myTableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        
        return UITableViewCell()
    }
    
    func getRowCountFor(section: Int) -> Int{
        
        if section == diningSectionIndex { return arrFavDining.value.count }
        if section == drinkingSectionIndex { return arrFavDrinking.value.count }
        if section == activitySectionIndex { return arrFavActivities.value.count }
        if section == shoppingSectionIndex { return arrFavShopping.value.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRowCountFor(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
        
        return rowHeight
    }
}
