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
    var imageList : [String]?
    var type: Endpoint?
    
    enum CodingKeys: String, CodingKey {
        case descriptionField = "description"
        case feedUrl = "feed_url"
        case homePageUrl = "home_page_url"
        case items = "items"
        case title = "title"
        case userComment = "user_comment"
        case version = "version"
        case imageList = "image_list"
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
        imageList = try values.decodeIfPresent([String].self, forKey: .imageList)
    }
    
    init(descriptionField: String,
         feedUrl: String,
         homePageUrl: String,
         items: [BOCatItem],
         title: String,
         userComment: String,
         version: String,
         type: Endpoint,
         imageList: [String]?){
        
        self.descriptionField = descriptionField
        self.feedUrl = feedUrl
        self.homePageUrl = homePageUrl
        self.items = items
        self.title = title
        self.userComment = userComment
        self.version = version
        self.type = type
        self.imageList = imageList
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

