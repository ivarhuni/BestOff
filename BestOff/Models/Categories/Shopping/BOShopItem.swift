//
//  BOItem.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 29, 2019

import Foundation
struct BOShopItem : Codable {

        let contentText : String
        let id : String
        let image : String
        let tags : [String]
        let title : String
        let url : String

        enum CodingKeys: String, CodingKey {
                case contentText = "content_text"
                case id = "id"
                case image = "image"
                case tags = "tags"
                case title = "title"
                case url = "url"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                contentText = try values.decode(String.self, forKey: .contentText)
                id = try values.decode(String.self, forKey: .id)
                image = try values.decode(String.self, forKey: .image)
                tags = try values.decode([String].self, forKey: .tags)
                title = try values.decode(String.self, forKey: .title)
                url = try values.decode(String.self, forKey: .url)
        }
}
