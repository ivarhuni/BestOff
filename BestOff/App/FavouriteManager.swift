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
    
    static func saveCatItemToFavourites(item: BOCatItem){
        
        print("saving an item to favourites")
        
        do{
            var arrFavourites = try getFavouriteItems()
            arrFavourites.insert(item, at: 0)
            saveArrToFavourites(arrFavourites: arrFavourites)
        } catch{
            print(error)
            print("save item item to favs failed")
        }
    }
    
    static func saveItemToFavourites(item: BOCatItem){
        
        print("saving an item to favourites")
        do{
            var arrFavourites = try getFavouriteItems()
            arrFavourites.insert(item, at: 0)
            saveArrToFavourites(arrFavourites: arrFavourites)
        } catch{
            print(error)
            print("save error")
        }
    }
    
    static func saveArrToFavourites(arrFavourites: [BOCatItem]){
        
        print("saving to favourites")
        let data = arrFavourites.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: userDefaultFavsKey)
    }
    
    static func getFavouriteItems() throws -> [BOCatItem]{
        
        print("loading favourites")
        
        guard let encodedData = UserDefaults.standard.array(forKey: userDefaultFavsKey) as? [Data] else {
            return []
        }
        
        do {
            let arrItems = try encodedData.map { try JSONDecoder().decode(BOCatItem.self, from: $0) }
            var arrItemsCopy: [BOCatItem] = []
            for item in arrItems{
                
                var itemCopy = item
                itemCopy.type = .rvkDrink
                itemCopy.setDetailItemFor(type: .rvkDrink)
                itemCopy.detailItem?.type = .rvkDrink
                arrItemsCopy.append(itemCopy)
                print("")
            }
            return arrItemsCopy
        }catch {
            return []
        }
    }
    
    static func removeItemWith(strId: String){
        
        print("removing an item with ID " + strId + " from favourites")
        
        do{
            var arrFavourites = try getFavouriteItems()
            arrFavourites = arrFavourites.filter{ $0.id != strId }
            saveArrToFavourites(arrFavourites: arrFavourites)
        } catch{
            print(error)
            print("removeItem error")
        }
        
    }
    
    static func isItemFavourited(item: BOCatItem) -> Bool{
        
        do{
            let arrFavs = try getFavouriteItems()
            for favItem in arrFavs{
                if favItem.id == item.id{
                    print("item is favourited")
                    return true
                }
            }
            return false
        } catch{
            print("eror isItemFavourited")
            return false
        }
    }
    
    static func addOrRemoveToFavs(item: BOCatItem){
        
        if isItemFavourited(item: item){
            removeItemWith(strId: item.id)
            return
        }
        saveItemToFavourites(item: item)
    }
}
