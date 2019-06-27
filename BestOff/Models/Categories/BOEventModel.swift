//
//  BOEventModel.swift
//  BestOff
//
//  Created by Ivar Johannesson on 27/06/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

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


