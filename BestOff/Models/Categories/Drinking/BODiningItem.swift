//
//  BOItem.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on April 1, 2019

import Foundation

struct BODiningItem : Codable {

        let contentHtml : String
        let contentText : String
        let dateModified : String
        let datePublished : String
        let id : String
        let image : String
        let tags : [String]
        let title : String
        let url : String

        enum CodingKeys: String, CodingKey {
                case contentHtml = "content_html"
                case contentText = "content_text"
                case dateModified = "date_modified"
                case datePublished = "date_published"
                case id = "id"
                case image = "image"
                case tags = "tags"
                case title = "title"
                case url = "url"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                contentHtml = try values.decode(String.self, forKey: .contentHtml)
                contentText = try values.decode(String.self, forKey: .contentText)
                dateModified = try values.decode(String.self, forKey: .dateModified)
                datePublished = try values.decode(String.self, forKey: .datePublished)
                id = try values.decode(String.self, forKey: .id)
                image = try values.decode(String.self, forKey: .image)
                tags = try values.decode([String].self, forKey: .tags)
                title = try values.decode(String.self, forKey: .title)
                url = try values.decode(String.self, forKey: .url)
            
            
        }
}
