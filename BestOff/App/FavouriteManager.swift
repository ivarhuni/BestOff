//
//  FavouriteManager.swift
//  BestOff
//
//  Created by Ivar Johannesson on 29/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

struct FavouriteManager{
    
    static let userDefaultFavsKey = "Favourites"
    
    static func saveItemToFavourites(item: BOCategoryDetailItem){
        
        print("saving an item to favourites")
        var arrFavourites = getFavouriteItems()
        arrFavourites.insert(item, at: 0)
        saveArrToFavourites(arrFavourites: arrFavourites)
    }
    
    static func saveArrToFavourites(arrFavourites: [BOCategoryDetailItem]){
        
        print("saving to favourites")
        let data = arrFavourites.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: userDefaultFavsKey)
    }
    
    static func getFavouriteItems() -> [BOCategoryDetailItem]{
        
        print("loading favourites")
        
        guard let encodedData = UserDefaults.standard.array(forKey: userDefaultFavsKey) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(BOCategoryDetailItem.self, from: $0) }
    }
    
    static func removeItemWith(name: String){
        
        print("removing an item with name " + name + " from favourites")
        var arrFavourites = getFavouriteItems()
        arrFavourites = arrFavourites.filter{ $0.itemName != name }
        saveArrToFavourites(arrFavourites: arrFavourites)
    }
    
    static func mockFavs() -> [BOCategoryDetailItem] {
        
        //MOCK
        print("mocking favourites")
        let burgerURL = "https://www.iheartnaptime.net/wp-content/uploads/2018/05/hamburger-recipe-1200x960.jpg"
        let firstDetailItem = BOCategoryDetailItem.init(itemName: "First", itemAddress: "First Address", itemDescription: "SomeReallyLong Desc", imageURL: burgerURL)
        let secondDetailItem = BOCategoryDetailItem.init(itemName: "Second Item", itemAddress: "First Address", itemDescription: "SomeReallyLong Desc", imageURL: burgerURL)
        let thirdItem = BOCategoryDetailItem.init(itemName: "Third Item Long Name", itemAddress: "First Address", itemDescription: "SomeReallyLong Desc", imageURL: burgerURL)
        let forthItem = BOCategoryDetailItem.init(itemName: "4 Item Long Name :) Because why not", itemAddress: "First Address", itemDescription: "SomeReallyLong Desc", imageURL: burgerURL)
        
        let arrMock = [firstDetailItem, secondDetailItem, thirdItem, forthItem]
        
        saveArrToFavourites(arrFavourites: arrMock)
        return arrMock
    }
}
