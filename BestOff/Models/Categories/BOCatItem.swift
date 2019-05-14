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
    let tags : [String]
    let title : String
    let url : String
    let author: BOAuthor
    let strTimeStamp: String
    
    enum CodingKeys: String, CodingKey {
        case contentText = "content_text"
        case contentHtml = "content_html"
        case id = "id"
        case image = "image"
        case tags = "tags"
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
        tags = try values.decode([String].self, forKey: .tags)
        title = try values.decode(String.self, forKey: .title)
        url = try values.decode(String.self, forKey: .url)
        author = try values.decode(BOAuthor.self, forKey: .author)
        strTimeStamp = ""
       
    }
    
    func getStrDateFromStrURL(strURL: String) -> String{
        
        let arrURL = self.url.split(separator: "/")
        
        let indexOfLastObject = arrURL.count - 1
        
        guard let strDay = arrURL[safe: indexOfLastObject] else { return "" }
        guard let strMonth = arrURL[safe: indexOfLastObject - 1] else { return "" }
        guard let strYear = arrURL[safe: indexOfLastObject - 2 ] else { return "" }

        
        return strDay + ". " + strMonth + " " + strYear + "'"
    }
    
    
}
