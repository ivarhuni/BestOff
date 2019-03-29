//
//  BOItem.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 29, 2019

import Foundation
import SwiftyJSON


class BOCatShoppingItem : NSObject, NSCoding{

    var author : BOCatAuthor!
    var contentHtml : String!
    var contentText : String!
    var dateModified : String!
    var datePublished : String!
    var id : String!
    var image : String!
    var tags : [String]!
    var title : String!
    var url : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        let authorJson = json["author"]
        if !authorJson.isEmpty{
            author = BOCatAuthor(fromJson: authorJson)
        }
        contentHtml = json["content_html"].stringValue
        contentText = json["content_text"].stringValue
        dateModified = json["date_modified"].stringValue
        datePublished = json["date_published"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        tags = [String]()
        let tagsArray = json["tags"].arrayValue
        for tagsJson in tagsArray{
            tags.append(tagsJson.stringValue)
        }
        title = json["title"].stringValue
        url = json["url"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if author != nil{
        	dictionary["author"] = author.toDictionary()
        }
        if contentHtml != nil{
        	dictionary["content_html"] = contentHtml
        }
        if contentText != nil{
        	dictionary["content_text"] = contentText
        }
        if dateModified != nil{
        	dictionary["date_modified"] = dateModified
        }
        if datePublished != nil{
        	dictionary["date_published"] = datePublished
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if image != nil{
        	dictionary["image"] = image
        }
        if tags != nil{
        	dictionary["tags"] = tags
        }
        if title != nil{
        	dictionary["title"] = title
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
		author = aDecoder.decodeObject(forKey: "author") as? BOCatAuthor
		contentHtml = aDecoder.decodeObject(forKey: "content_html") as? String
		contentText = aDecoder.decodeObject(forKey: "content_text") as? String
		dateModified = aDecoder.decodeObject(forKey: "date_modified") as? String
		datePublished = aDecoder.decodeObject(forKey: "date_published") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		tags = aDecoder.decodeObject(forKey: "tags") as? [String]
		title = aDecoder.decodeObject(forKey: "title") as? String
		url = aDecoder.decodeObject(forKey: "url") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if author != nil{
			aCoder.encode(author, forKey: "author")
		}
		if contentHtml != nil{
			aCoder.encode(contentHtml, forKey: "content_html")
		}
		if contentText != nil{
			aCoder.encode(contentText, forKey: "content_text")
		}
		if dateModified != nil{
			aCoder.encode(dateModified, forKey: "date_modified")
		}
		if datePublished != nil{
			aCoder.encode(datePublished, forKey: "date_published")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if tags != nil{
			aCoder.encode(tags, forKey: "tags")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}
		if url != nil{
			aCoder.encode(url, forKey: "url")
		}

	}

}
