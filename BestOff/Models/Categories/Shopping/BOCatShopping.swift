//
//  BOCItemShopping.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 29, 2019

import Foundation
import SwiftyJSON


class BOCatShopping : NSObject, NSCoding{

    var descriptionField : String!
    var feedUrl : String!
    var homePageUrl : String!
    var items : [BOCatShoppingItem]!
    var title : String!
    var userComment : String!
    var version : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        descriptionField = json["description"].stringValue
        feedUrl = json["feed_url"].stringValue
        homePageUrl = json["home_page_url"].stringValue
        items = [BOCatShoppingItem]()
        let itemsArray = json["items"].arrayValue
        for itemsJson in itemsArray{
            let value = BOCatShoppingItem(fromJson: itemsJson)
            items.append(value)
        }
        title = json["title"].stringValue
        userComment = json["user_comment"].stringValue
        version = json["version"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if descriptionField != nil{
        	dictionary["description"] = descriptionField
        }
        if feedUrl != nil{
        	dictionary["feed_url"] = feedUrl
        }
        if homePageUrl != nil{
        	dictionary["home_page_url"] = homePageUrl
        }
        if items != nil{
        var dictionaryElements = [[String:Any]]()
        for itemsElement in items {
        	dictionaryElements.append(itemsElement.toDictionary())
        }
        dictionary["items"] = dictionaryElements
        }
        if title != nil{
        	dictionary["title"] = title
        }
        if userComment != nil{
        	dictionary["user_comment"] = userComment
        }
        if version != nil{
        	dictionary["version"] = version
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		descriptionField = aDecoder.decodeObject(forKey: "description") as? String
		feedUrl = aDecoder.decodeObject(forKey: "feed_url") as? String
		homePageUrl = aDecoder.decodeObject(forKey: "home_page_url") as? String
		items = aDecoder.decodeObject(forKey: "items") as? [BOCatShoppingItem]
		title = aDecoder.decodeObject(forKey: "title") as? String
		userComment = aDecoder.decodeObject(forKey: "user_comment") as? String
		version = aDecoder.decodeObject(forKey: "version") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if feedUrl != nil{
			aCoder.encode(feedUrl, forKey: "feed_url")
		}
		if homePageUrl != nil{
			aCoder.encode(homePageUrl, forKey: "home_page_url")
		}
		if items != nil{
			aCoder.encode(items, forKey: "items")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}
		if userComment != nil{
			aCoder.encode(userComment, forKey: "user_comment")
		}
		if version != nil{
			aCoder.encode(version, forKey: "version")
		}

	}

}
