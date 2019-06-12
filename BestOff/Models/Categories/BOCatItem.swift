//
//  BOCatItem.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

import Foundation
struct BOCatItem : Codable {
    
    let contentText : String
    let contentHtml : String
    let id : String
    let image : String
    let title : String
    let url : String
    let author: BOAuthor
    var detailItem: BOCategoryDetail?
    var strTimeStamp: String?
    var superCatName: String?
    var titleShort: String?
    var type: Endpoint?
    
    enum CodingKeys: String, CodingKey {
        case contentText = "content_text"
        case contentHtml = "content_html"
        case id = "id"
        case image = "image"
        case title = "title"
        case url = "url"
        case author = "author"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        contentText = try values.decode(String.self, forKey: .contentText)
        contentHtml = try values.decode(String.self, forKey: .contentHtml)
        id = try values.decode(String.self, forKey: .id)
        image = try values.decode(String.self, forKey: .image)
        title = try values.decode(String.self, forKey: .title)
        url = try values.decode(String.self, forKey: .url)
        author = try values.decode(BOAuthor.self, forKey: .author)
        detailItem = nil
        strTimeStamp = nil
        superCatName = ""
        titleShort = ""
        tryToSetTimeStamp()
    }
}

extension BOCatItem{
    
    mutating func setDetailItemFor(type: Endpoint){
        
        switch type {
        case .rvkDrink, .rvkActivities, .rvkShopping, .rvkDining, .north, .east, .west, .westfjords, .south, .reykjanes:
            
            
            guard let categoryDetail = DetailItemFactory.createCategoryDetailForRvk(categoryItemContentText: contentText, strHTML: contentHtml) else {
                
                print("Creating CategoryDetail failed in :" + self.title)
                return
            }
            detailItem = categoryDetail
            setTitleShort()
            return
        case .guides:
            
            guard let guideDetail = DetailItemFactory.createCategoryDetailFromText(categoryItemContentText: contentText, strHTML: contentHtml) else {
                
                print("Creating CategoryDetail failed in :" + self.title)
                return
            }
            detailItem = guideDetail
            setTitleShort()
            return
        }
    }
}


extension BOCatItem{
    
    mutating func tryToSetTimeStamp(){
        guard let timeStampFromURL = getStrDateFromStrURL(strURL: self.url) else { return }
        strTimeStamp = timeStampFromURL
    }
    
    func getStrDateFromStrURL(strURL: String) -> String?{
        
        let arrURL = strURL.split(separator: "/")
        
        let indexOfLastObject = arrURL.count - 1
        
        guard let strDay = arrURL[safe: indexOfLastObject-1] else { return nil }
        guard let strMonth = arrURL[safe: indexOfLastObject - 2] else { return nil }
        guard let strMonthName = BOCatItem.getMonthNameFromStrMonthNumber(strMonthName: String(strMonth)) else { return nil }
        guard let strYear = arrURL[safe: indexOfLastObject - 3] else { return nil }
        
        if strYear.count != 4 { return nil }
        let lastTwoDigitsYear = strYear.suffix(2)
        
        return strDay + ". " + strMonthName + " " + lastTwoDigitsYear + "'"
    }
    
    static func getMonthNameFromStrMonthNumber(strMonthName: String) -> String? {
        
        guard let intMonth = Int(strMonthName) else { return nil }
        if (intMonth < 1) { return nil }
        
        return DateFormatter().monthSymbols[intMonth - 1]
    }
}

extension BOCatItem{
    
    static func getScreenTitleText() -> String{
        
        return ""
    }
}

extension BOCatItem{
    
    mutating func setTitleShort(){
        
        guard let titleSplit = detailItem?.categoryTitle.split(separator: ":") else { return }
        guard let shortTitle = titleSplit[safe: 1] else { return }
        titleShort = String(shortTitle)
        print("")
    }
}
