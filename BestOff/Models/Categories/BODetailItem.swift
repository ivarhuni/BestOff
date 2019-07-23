//
//  BODetailItem.swift
//  BestOff
//
//  Created by Ivar Johannesson on 01/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation


//Each category item actually contains three items within the CategoryItem.contentText
//The Winner for that category item [Best Burger, Best Late Night Restaurant, etc] plus two runner ups
//The API doesn't have properties CategoryItem.winner or CategoryItem.runnerUp
//The winners + runner ups are contained within
//And we have to construct them manually
//The format seems to be as follows:

/*Text Format:
 
 <Category>.item.contentText =
 
 <Text which describes the category Item>...
 \n\n\n     <Title Of Item>
 \n         <Item Winner Name>
 \n         <Item Winner Address>
 \n\n       <Item Winner Description>
 
 \n\n\n     "Runner-Up:"
 \n         <Runner Up Name>
 \n         <Runner Up Address>
 \n\n       <Runner Up Description>
 
 \n\n\n     "Runner-Up:"
 \n         <Runner Up2 Name>
 \n         <Runner Up2 Address>
 \n\n       <Runner Up2 Description>
 
 \n\n\n     "Previous Winners"
 \n         <Year Of Win>: <Winner For That Year>
 \n         <Year Of Win>: <Winner For That Year>
 
 */

struct BOCategoryDetail{
    let categoryDescription: String
    let categoryTitle: String
    var arrItems: [BOCategoryDetailItem] = []
    var type: Endpoint? = nil
}

struct BOCategoryDetailItem: Codable{
    let itemName: String
    let itemAddress: String
    let itemDescription: String
    let imageURL: String?
    let isWinner: Bool
    let isFirstRunner: Bool
    let isSecondRunner: Bool
    
    let categoryWinnerOrRunnerTitle: String
    
    init(itemName: String,
         itemAddress: String,
         itemDescription: String,
         imageURL: String,
         isWinner: Bool = false,
         isFirstRunner: Bool = false,
         isSecondRunner: Bool = false,
         categoryWinnerOrRunnerTitle: String = "") {
        
        self.itemName = itemName
        self.itemAddress = itemAddress
        self.itemDescription = itemDescription
        self.imageURL = imageURL
        self.isWinner = isWinner
        self.isFirstRunner = isFirstRunner
        self.isSecondRunner = isSecondRunner
        
        self.categoryWinnerOrRunnerTitle = categoryWinnerOrRunnerTitle
    }
}


struct DetailItemFactory{
    
    //These are the array positions of the name/Description/title String in the
    //contentDescription field in the categoryJSON.contentText,
    //when the categoryJSON.contentText is split up with
    //.componentsSeparatedBy "\n"
    
    private enum arrIndexItemsGuide: Int{
        case catDescription = 0
        case categoryName = 3
    }
    
    private enum arrIndexForDetailItemsGuide: Int{
        
        case firstItemName = 0
        case firstItemAddress = 1
        case firstItemDescription = 2
    }
    
    private enum arrIndexForDetailItems: Int{
        
        case categoryTitle = 0
        case itemWinnerName = 1
        case itemWinnerAddress = 2
        case itemWinnerDescription = 3
        
        case runnerUpCategoryTitle = 4
        case runnerUpName = 5
        case runnerUpAddress = 6
        case runnerUpDescription = 7
        
        case secondRunnerUpCategoryTitle = 8
        case sceondRunnerUpName = 9
        case secondRunnerUpAddress = 10
        case secondRunnerUpDescription = 11
    }
    
    
    
    static func createCategoryDetailFromText(categoryItemContentText: String, strHTML: String) -> BOCategoryDetail?{
        
        let arrText = categoryItemContentText.components(separatedBy: "\n")
        
        guard let catDescription = arrText[safe: arrIndexItemsGuide.catDescription.rawValue] else{
            print("--!-- MODEL ERROR: CategoryItemDescription unavailable --!-- ")
            return nil
        }
        guard let catName = arrText[safe: arrIndexItemsGuide.categoryName.rawValue] else{
            print("--!-- MODEL ERROR: CategoryItemName unavailable --!-- ")
            return nil
        }
        
        let catDescFiltered = catDescription.stringByDecodingHTMLEntities
        let catNameFiltered = catName.stringByDecodingHTMLEntities
        
        
        return BOCategoryDetail(categoryDescription: catDescFiltered, categoryTitle: catNameFiltered, arrItems: createDetailItemsForGuide(arrTextContent: arrText, strHTML: strHTML), type: nil)
    }
    
    static func createCategoryDetailForRvk(categoryItemContentText: String, strHTML: String) -> BOCategoryDetail?{
        
        let arrText = categoryItemContentText.components(separatedBy: "\n")
        
        guard let catDescription = arrText[safe: arrIndexItemsGuide.catDescription.rawValue] else{
            print("--!-- MODEL ERROR: CategoryItemDescription unavailable --!-- ")
            return nil
        }
        guard let catName = arrText[safe: arrIndexItemsGuide.categoryName.rawValue] else{
            print("--!-- MODEL ERROR: CategoryItemName unavailable --!-- ")
            return nil
        }
        
        let catDescFiltered = catDescription.stringByDecodingHTMLEntities
        let catNameFiltred = catName.stringByDecodingHTMLEntities
        
        return BOCategoryDetail(categoryDescription: catDescFiltered, categoryTitle: catNameFiltred, arrItems: createDetailItemsForRvkWith(arrTextContent: arrText, strHTML: strHTML), type: nil)
    }
    
    static func createCategoryDetailForIce(categoryItemContentText: String, strHTML: String) -> BOCategoryDetail?{
        
        let arrText = categoryItemContentText.components(separatedBy: "\n")
        
        guard let catDescription = arrText[safe: arrIndexItemsGuide.catDescription.rawValue] else{
            print("--!-- MODEL ERROR: CategoryItemDescription unavailable --!-- ")
            return nil
        }
        guard let catName = arrText[safe: arrIndexItemsGuide.categoryName.rawValue] else{
            print("--!-- MODEL ERROR: CategoryItemName unavailable --!-- ")
            return nil
        }
        
        return BOCategoryDetail(categoryDescription: catDescription, categoryTitle: catName, arrItems: createDetailItemsForRvkWith(arrTextContent: arrText, strHTML: strHTML), type: nil)
    }
    
    
    private static func createDetailItemsForRvkWith(arrTextContent: [String], strHTML: String) -> [BOCategoryDetailItem]{
        
        let arrTxt = filterNonItemsFromRvk(array: arrTextContent)
        
        guard let catWinnerTitle = arrTxt[safe: arrIndexForDetailItems.categoryTitle.rawValue] else{
            print("--!-- MODEL ERROR: categoryDetailItem doesn't have winner --!-- ")
            return []
        }
        
        guard let itemWinnerName = arrTxt[safe: arrIndexForDetailItems.itemWinnerName.rawValue] else{
            print("--!-- MODEL ERROR: categoryDetailItem doesn't have winner --!-- ")
            return []
        }
        guard let itemWinnerAddress = arrTxt[safe: arrIndexForDetailItems.itemWinnerAddress.rawValue] else{
            print("--!-- MODEL ERROR: categoryDetailItem doesn't have winner address --!-- ")
            return []
        }
        guard let itemWinnerDescription = arrTxt[safe: arrIndexForDetailItems.itemWinnerDescription.rawValue] else{
            print("--!-- MODEL ERROR: categoryDetailItem doesn't have winner description --!-- ")
            return []
        }
        
        let arrImageURLs = getImageURLsFromHTMLString(strHTML)
        var winnerURL = ""
        var runnerUpURL = ""
        var secondRunnerUpURL = ""
        
        if let winnerUrl = arrImageURLs[safe: arrIndexImgURL.winnerImgURL.rawValue]{
            winnerURL = winnerUrl
        }
        if let runnerUpUrl = arrImageURLs[safe: arrIndexImgURL.firstRunnerUpImgURL.rawValue]{
            runnerUpURL = runnerUpUrl
        }
        if let secondRunnerUpUrl = arrImageURLs[safe: arrIndexImgURL.secondRunnerUpImgURL.rawValue]{
            secondRunnerUpURL = secondRunnerUpUrl
        }
        
        let winner = BOCategoryDetailItem(itemName: itemWinnerName,
                                          itemAddress: itemWinnerAddress,
                                          itemDescription: itemWinnerDescription,
                                          imageURL: winnerURL,
                                          isWinner: true,
                                          categoryWinnerOrRunnerTitle: catWinnerTitle)
        
        var detailItems: [BOCategoryDetailItem] = [winner]
        
        guard let runnerUpCategoryTitle = arrTxt[safe: arrIndexForDetailItems.runnerUpCategoryTitle.rawValue] else{
            print("--!-- MODEL ERROR: First Runner Up Parsing Error Name--!--")
            return detailItems
        }
        
        guard let firstRunnerUpName = arrTxt[safe: arrIndexForDetailItems.runnerUpName.rawValue] else{
            print("--!-- MODEL ERROR: First Runner Up Parsing Error Name--!--")
            return detailItems
        }
        guard let firstRunnerUpAddress = arrTxt[safe: arrIndexForDetailItems.runnerUpAddress.rawValue] else{
            print("--!-- MODEL ERROR: First Runner Up Parsing Error Address --!-- ")
            return detailItems
        }
        guard let firstRunnerUpDesc = arrTxt[safe: arrIndexForDetailItems.runnerUpDescription.rawValue] else{
            print("--!-- MODEL ERROR: First Runner Up Parsing Error Description--!-- ")
            return detailItems
        }
        
        let runnerUp = BOCategoryDetailItem(itemName: firstRunnerUpName,
                                            itemAddress: firstRunnerUpAddress,
                                            itemDescription: firstRunnerUpDesc,
                                            imageURL: runnerUpURL,
                                            isFirstRunner: true,
                                            categoryWinnerOrRunnerTitle: runnerUpCategoryTitle)
        
        detailItems.append(runnerUp)
        
        guard let secondRunnerUpCategoryTitle = arrTxt[safe: arrIndexForDetailItems.secondRunnerUpCategoryTitle.rawValue] else{
            print("--!-- MODEL ERROR: First Runner Up Parsing Error Name--!--")
            return detailItems
        }
        
        guard let secondRunnerUpName = arrTxt[safe: arrIndexForDetailItems.sceondRunnerUpName.rawValue] else{
            print("--!-- MODEL ERROR: Second Runner Up Parsing Error Name --!-- ")
            return detailItems
        }
        guard let secondRunnerUpAddress = arrTxt[safe: arrIndexForDetailItems.secondRunnerUpAddress.rawValue] else{
            print("--!-- MODEL ERROR: Second Runner Up Parsing Address --!-- ")
            return detailItems
        }
        guard let secondRunnerUpDesc = arrTxt[safe: arrIndexForDetailItems.secondRunnerUpDescription.rawValue] else{
            print("--!-- MODEL ERROR: Second Runner Up Parsing Description  --!-- ")
            return detailItems
        }
        
        let secondRunnerUp = BOCategoryDetailItem(itemName: secondRunnerUpName,
                                                  itemAddress: secondRunnerUpAddress,
                                                  itemDescription: secondRunnerUpDesc,
                                                  imageURL: secondRunnerUpURL,
                                                  isSecondRunner: true,
                                                  categoryWinnerOrRunnerTitle: secondRunnerUpCategoryTitle)
        
        detailItems.append(secondRunnerUp)
        
        return detailItems
    }
    
    //DetailItems are the items contained within ContentItem.Text
    private static func createDetailItemsForGuide(arrTextContent: [String], strHTML: String) -> [BOCategoryDetailItem]{
        
        let arrText = filterNonItemsFromGuides(array: arrTextContent)
        
        let indexGapForNewItem = 3
        
        var nextItemNameIndex = arrIndexForDetailItemsGuide.firstItemName.rawValue
        var nextItemAddressIndex = arrIndexForDetailItemsGuide.firstItemAddress.rawValue
        var nextItemDescriptionIndex = arrIndexForDetailItemsGuide.firstItemDescription.rawValue
        
        let numberOfItemsToMakeADetailItem = 3.0
        
        let maximumPossibleDetailItems = Int( round( Double(arrText.count) / numberOfItemsToMakeADetailItem) )
        
        let arrImageURLs = getImageURLsFromHTMLString(strHTML)
        
        var detailItems: [BOCategoryDetailItem] = []
        
        for index in 0...maximumPossibleDetailItems{
            
            guard let itemName = arrText[safe: nextItemNameIndex] else {
                
                //print("error fetching item name")
                return detailItems }
            guard let itemAddress = arrText[safe: nextItemAddressIndex] else {
                
                //print("Error fetching itemAddress")
                return detailItems
            }
            guard let itemDescription = arrText[safe: nextItemDescriptionIndex] else {
                
                //print("Error fetching itemDescription")
                return detailItems }
            guard let itemImgURL = arrImageURLs[safe: index] else {
                
                //print("Error fetching img URL")
                return detailItems
            }
            
            let item = BOCategoryDetailItem(itemName: itemName, itemAddress: itemAddress, itemDescription: itemDescription, imageURL: itemImgURL)
            detailItems.append(item)
            
            nextItemNameIndex = nextItemNameIndex + indexGapForNewItem
            nextItemAddressIndex = nextItemAddressIndex + indexGapForNewItem
            nextItemDescriptionIndex = nextItemDescriptionIndex + indexGapForNewItem
        }
        
        return detailItems
        //
        //
        //
        //        guard let itemWinnerName = arrTextContent[safe: arrIndexItems.itemWinnerName.rawValue] else{
        //            print("--!-- MODEL ERROR: categoryDetailItem doesn't have winner --!-- ")
        //            return []
        //        }
        //        guard let itemWinnerAddress = arrTextContent[safe: arrIndexItems.itemWinnerAddress.rawValue] else{
        //            print("--!-- MODEL ERROR: categoryDetailItem doesn't have winner address --!-- ")
        //            return []
        //        }
        //        guard let itemWinnerDescription = arrTextContent[safe: arrIndexItems.itemWinnerDescription.rawValue] else{
        //            print("--!-- MODEL ERROR: categoryDetailItem doesn't have winner description --!-- ")
        //            return []
        //        }
        //
        //        let arrImageURLs = getImageURLsFromHTMLString(strHTML)
        //        var winnerURL = ""
        //        var runnerUpURL = ""
        //        var secondRunnerUpURL = ""
        //
        //        if let winnerUrl = arrImageURLs[safe: arrIndexImgURL.winnerImgURL.rawValue]{
        //            winnerURL = winnerUrl
        //        }
        //        if let runnerUpUrl = arrImageURLs[safe: arrIndexImgURL.firstRunnerUpImgURL.rawValue]{
        //            runnerUpURL = runnerUpUrl
        //        }
        //        if let secondRunnerUpUrl = arrImageURLs[safe: arrIndexImgURL.secondRunnerUpImgURL.rawValue]{
        //            secondRunnerUpURL = secondRunnerUpUrl
        //        }
        //
        //        let winner = BOCategoryDetailItem(itemName: itemWinnerName,
        //                                          itemAddress: itemWinnerAddress,
        //                                          itemDescription: itemWinnerDescription,
        //                                          imageURL: winnerURL,
        //                                          isWinner: true)
        //        var detailItems: [BOCategoryDetailItem] = [winner]
        //
        //        guard let firstRunnerUpName = arrTextContent[safe: arrIndexItems.firstRunnerUpName.rawValue] else{
        //            print("--!-- MODEL ERROR: First Runner Up Parsing Error Name--!--")
        //            return detailItems
        //        }
        //        guard let firstRunnerUpAddress = arrTextContent[safe: arrIndexItems.firstRunnerUpAddress.rawValue] else{
        //            print("--!-- MODEL ERROR: First Runner Up Parsing Error Address --!-- ")
        //            return detailItems
        //        }
        //        guard let firstRunnerUpDesc = arrTextContent[safe: arrIndexItems.firstRunnerUpDescription.rawValue] else{
        //            print("--!-- MODEL ERROR: First Runner Up Parsing Error Description--!-- ")
        //            return detailItems
        //        }
        //
        //        let runnerUp = BOCategoryDetailItem(itemName: firstRunnerUpName,
        //                                                         itemAddress: firstRunnerUpAddress,
        //                                                         itemDescription: firstRunnerUpDesc,
        //                                                         imageURL: runnerUpURL,
        //                                                         isFirstRunner: true)
        //
        //        detailItems.append(runnerUp)
        //
        //        guard let secondRunnerUpName = arrTextContent[safe: arrIndexItems.secondRunnerUpName.rawValue] else{
        //            print("--!-- MODEL ERROR: Second Runner Up Parsing Error Name --!-- ")
        //            return detailItems
        //        }
        //        guard let secondRunnerUpAddress = arrTextContent[safe: arrIndexItems.secondRunnerUpAddress.rawValue] else{
        //            print("--!-- MODEL ERROR: Second Runner Up Parsing Address --!-- ")
        //            return detailItems
        //        }
        //        guard let secondRunnerUpDesc = arrTextContent[safe: arrIndexItems.secondRunnerUpDescription.rawValue] else{
        //            print("--!-- MODEL ERROR: Second Runner Up Parsing Description  --!-- ")
        //            return detailItems
        //        }
        //
        //        let secondRunnerUp = BOCategoryDetailItem(itemName: secondRunnerUpName,
        //                                                               itemAddress: secondRunnerUpAddress,
        //                                                               itemDescription: secondRunnerUpDesc,
        //                                                               imageURL: secondRunnerUpURL,
        //                                                               isSecondRunner: true)
        //
        //        detailItems.append(secondRunnerUp)
        //
        //        //Guides have more than winner + 2 x runner ups detail items
        //        getAdditionalItemsFrom(arrTexts: arrTextContent, currentDetailItemsCount: detailItems.count, strHTML: strHTML)
        //
        //        return detailItems
    }
}

extension DetailItemFactory{
    
    static func commonFiltering(array: [String]) -> [String]{
        
        var arrText = array
        
        //Read More Guides to iceland here... not part of detailitem
        arrText.removeLast()
        
        //DetailCategory Title
        arrText.removeFirst()
        
        //Seperator
        arrText = arrText.filter{
            $0 != ""
        }
        
        var strArray: [String] = []
        for encodedText in arrText{
            
            let decodedText = encodedText.stringByDecodingHTMLEntities
            
            let omgIHateHTMLStrings = decodedText.replacingOccurrences(of: "&#038;", with: "&")
            
            if omgIHateHTMLStrings.contains("&#8217;"){
                print("")
            }
            
            let omgIHateHTMLStrings2 = omgIHateHTMLStrings.replacingOccurrences(of: "&#8217;", with: "'")
            
            
            strArray.append(omgIHateHTMLStrings2)
        }
        
        return strArray
    }
    
    static func filterNonItemsFromGuides(array: [String]) -> [String]{
        
        var arrText = array
        
        arrText = commonFiltering(array: arrText)
        
        arrText = arrText.filter{
            
            !$0.contains("appeared first on The Reykjavik Grapevine.")
        }
        
        arrText = arrText.filter{
            $0 != "Book now"
        }
        arrText = arrText.filter{
            !$0.contains("Load&#")
        }
        
        var strArray: [String] = []
        for encodedText in arrText{
            
            let decodedText = encodedText.stringByDecodingHTMLEntities
            
            let omgIHateHTMLStrings = decodedText.replacingOccurrences(of: "&#038;", with: "&")
            
            if omgIHateHTMLStrings.contains("&#8217;"){
                print("")
            }
            
            if omgIHateHTMLStrings.contains("&#8217;"){
                print("")
            }
            
            let omgIHateHTMLStrings2 = omgIHateHTMLStrings.replacingOccurrences(of: "&#8217;", with: "'")
            
            
            strArray.append(omgIHateHTMLStrings2)
        }
        
        guard let _ = strArray[safe: 3] else { return arrText }
        guard let _ = strArray[safe: 4] else { return arrText }
        
        return strArray
    }
    
    static func filterNonItemsFromRvk(array: [String]) -> [String]{
        
        return commonFiltering(array: array)
    }
}

private let characterEntities : [ Substring : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
    
    //Special
    "&#038;"    : "&"
]


extension String {
    
    
    
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {
        
        // ===== Utility functions =====
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(_ string : Substring, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity : Substring) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
                return decodeNumeric(entity.dropFirst(3).dropLast(), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.dropFirst(2).dropLast(), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // ===== Method starts here =====
        
        var result = ""
        var position = startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self[position...].range(of: "&") {
            result.append(contentsOf: self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            guard let semiRange = self[position...].range(of: ";") else {
                // No matching ';'.
                break
            }
            let entity = self[position ..< semiRange.upperBound]
            position = semiRange.upperBound
            
            if let decoded = decode(entity) {
                // Replace by decoded character:
                result.append(decoded)
            } else {
                // Invalid entity, copy verbatim:
                result.append(contentsOf: entity)
            }
        }
        // Copy remaining characters to `result`:
        result.append(contentsOf: self[position...])
        return result
    }
}

extension DetailItemFactory{
    
    private enum arrIndexImgURL: Int{
        case winnerImgURL = 0
        case firstRunnerUpImgURL = 1
        case secondRunnerUpImgURL = 2
    }
    
    private static func getImageURLsFromHTMLString(_ strHTML: String) -> [String]{
        
        let imgURLStrings = strHTML.extractURLs().filter { (url) -> Bool in
            url.contains("#main")
        }
        
        return imgURLStrings
    }
}
