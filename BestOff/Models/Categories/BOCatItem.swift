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
//    var sponsored : CustomFields?
    var detailItem: BOCategoryDetail?
    var strTimeStamp: String?
    var superCatName: String?
    var titleShort: String?
    var type: Endpoint?
    var imageList : [String]?
    
    enum CodingKeys: String, CodingKey {
        case contentText = "content_text"
        case contentHtml = "content_html"
        case id = "id"
        case image = "image"
        case title = "title"
        case url = "url"
        case author = "author"
        case imageList = "image_list"
//        case sponsored = "custom_fields"
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
        
        let unfilteredImgList: [String]? = try values.decodeIfPresent([String].self, forKey: .imageList)
        if let imgList = unfilteredImgList{
            imageList = filteredImageArray(imgUrlArray: imgList)
        }else{
            print("images failed for:")
            print(self.id)
            imageList = []
        }
        
//        sponsored = try values.decode(CustomFields.self, forKey: .sponsored)
        detailItem = nil
        strTimeStamp = nil
        superCatName = ""
        titleShort = ""
        tryToSetTimeStamp()
    }
    
    init(contentText: String, contentHtml: String, id: String, image: String, title: String, url: String, author: BOAuthor, timeStamp: String, imageList: [String]?){
        self.contentText = contentText
        self.contentHtml = contentHtml
        self.author = author
        self.id = id
        self.image = image
        self.title = title
        self.url = url
        self.imageList = imageList
        strTimeStamp = timeStamp
    }
    
    func filteredImageArray(imgUrlArray: [String]) -> [String]{
        
        guard let firstImage = imgUrlArray[safe: 0] else{
            return imgUrlArray
        }
        guard let secondImage = imgUrlArray[safe: imgUrlArray.count/2] else{
            return imgUrlArray
        }
        guard let thirdImage = imgUrlArray.last else{
            return imgUrlArray
        }
        return [firstImage, secondImage, thirdImage]
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
            
            if self.id == "https://grapevine.is/best-of-iceland/north/2019/06/10/best-of-north-iceland-2019-best-cafe/"{
                print("")
            }
            
            if type == .north || type == .east || type == .west || type == .westfjords || type == .south || type == .reykjanes{
                
                if var firstItem = detailItem?.arrItems.first, var secondItem = detailItem?.arrItems[safe: 1], var thirdItem = detailItem?.arrItems[safe: 2]{
                    if let firstImage = self.imageList?.first, let secondImage = self.imageList?[safe: 1], let thirdImage = self.imageList?[safe: 2]{
                        
                        thirdItem.imageURL = firstImage
                        secondItem.imageURL = secondImage
                        firstItem.imageURL = thirdImage

                        self.detailItem?.arrItems = [firstItem, secondItem, thirdItem]
                        print("")
                        
                    }else{
                        print("images failed for:")
                        print(self.id)
                    }
                }else{
                    print("item failed for:")
                    print(self.id)
                }
            }
            
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
        case .events:
            print("not setting detailitem for events")
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
        guard let shortTitle = titleSplit[safe: 0] else { return }
        titleShort = String(shortTitle)
       
    }
}
