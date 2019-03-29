//
//  BOCatShopping.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 29, 2019

import Foundation

struct BOCatShop : Codable {

        let descriptionField : String
        let feedUrl : String
        let homePageUrl : String
        let items : [BOCatShopItem]
        let title : String
        let userComment : String
        let version : String

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
                items = try values.decode([BOCatShopItem].self, forKey: .items)
                title = try values.decode(String.self, forKey: .title)
                userComment = try values.decode(String.self, forKey: .userComment)
                version = try values.decode(String.self, forKey: .version)
        }

}
