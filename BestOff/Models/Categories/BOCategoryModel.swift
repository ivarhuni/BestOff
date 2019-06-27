//
//  BOCategoryModel.swift
//  BestOff
//
//  Created by Ivar Johannesson on 15/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

struct BOCategoryModel: Codable{
    
    let descriptionField : String
    let feedUrl : String
    let homePageUrl : String
    var items : [BOCatItem]
    let title : String
    let userComment : String
    let version : String
    var type: Endpoint?
    
    enum CodingKeys: String, CodingKey {
        case descriptionField = "description"
        case feedUrl = "feed_url"
        case homePageUrl = "home_page_url"
        case items = "items"
        case title = "title"
        case userComment = "user_comment"
        case version = "version"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        descriptionField = try values.decode(String.self, forKey: .descriptionField)
        feedUrl = try values.decode(String.self, forKey: .feedUrl)
        homePageUrl = try values.decode(String.self, forKey: .homePageUrl)
        items = try values.decode([BOCatItem].self, forKey: .items)
        title = try values.decode(String.self, forKey: .title)
        userComment = try values.decode(String.self, forKey: .userComment)
        version = try values.decode(String.self, forKey: .version)
    }
}

extension BOCategoryModel{

    mutating func setType(type: Endpoint){
        self.type = type

        var arrItemsWithType: [BOCatItem] = []
        for item in self.items{
            
            var itemCopy = item
            itemCopy.setDetailItemFor(type: type)
            itemCopy.type = self.type
            arrItemsWithType.append(itemCopy)
        }
        self.items = arrItemsWithType
    }
}

struct BOEventModel: Codable{
    
    let about: String?
    let address: String?
    let day: String?
    let lat: String?
    let lng: String?
    let time : String?
    let title : String?
    let venue : String?
    let what : String?
    let imgUrl : String?
    var BOCategoryModel: BOCategoryModel?
    
    enum CodingKeys: String, CodingKey {
        
        case about = "about"
        case address = "address"
        case day = "day"
        case lat = "lat"
        case lng = "lng"
        case time = "time"
        case title = "title"
        case venue = "venue"
        case what  = "what"
        case imgUrl = "imgUrl"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        about = try values.decodeIfPresent(String.self, forKey: .about) ?? ""
        address = try values.decodeIfPresent(String.self, forKey: .address) ?? ""
        day = try values.decodeIfPresent(String.self, forKey: .day) ?? ""
        lat = try values.decodeIfPresent(String.self, forKey: .lat) ?? ""
        lng = try values.decodeIfPresent(String.self, forKey: .lng) ?? ""
        time = try values.decodeIfPresent(String.self, forKey: .time) ?? ""
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        venue = try values.decodeIfPresent(String.self, forKey: .venue) ?? ""
        what = try values.decodeIfPresent(String.self, forKey: .what) ?? ""
        imgUrl = try values.decodeIfPresent(String.self, forKey: .imgUrl) ?? ""
        
    }
}


