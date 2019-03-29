//
//  BOAuthor.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 29, 2019

import Foundation
import SwiftyJSON


class BOCatAuthor : NSObject, NSCoding{

    var avatar : String!
    var name : String!
    var url : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        avatar = json["avatar"].stringValue
        name = json["name"].stringValue
        url = json["url"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
        var dictionary = [String:Any]()
        if avatar != nil{
        	dictionary["avatar"] = avatar
        }
        if name != nil{
        	dictionary["name"] = name
        }
        if url != nil{
        	dictionary["url"] = url
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		avatar = aDecoder.decodeObject(forKey: "avatar") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		url = aDecoder.decodeObject(forKey: "url") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if avatar != nil{
			aCoder.encode(avatar, forKey: "avatar")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if url != nil{
			aCoder.encode(url, forKey: "url")
		}

	}

}
