//
//  BOAuthor.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on April 4, 2019

import Foundation

struct BOAuthor : Codable {

        let avatar : String
        let name : String
        let url : String

        enum CodingKeys: String, CodingKey {
                case avatar = "avatar"
                case name = "name"
                case url = "url"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                avatar = try values.decode(String.self, forKey: .avatar)
                name = try values.decode(String.self, forKey: .name)
                url = try values.decode(String.self, forKey: .url)
        }
    
    init(avatar: String, name: String, url: String){
        self.avatar = avatar
        self.name = name
        self.url = url
    }
}

struct CustomFields : Codable {
    
    let isSponsored : Bool
    
    enum CodingKeys: String, CodingKey {
        case isSponsored = "sponsored_article"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isSponsored = try values.decode(Bool.self, forKey: .isSponsored)
    }
}
