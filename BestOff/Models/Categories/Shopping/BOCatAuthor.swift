//
//  BOAuthor.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 29, 2019

import Foundation

struct BOCatAuthor : Codable {

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

}
