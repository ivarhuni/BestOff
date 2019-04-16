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
}

struct BOCategoryDetailItem{
    let itemName: String
    let itemAddress: String
    let itemDescription: String
    let imageURL: String?
    let isWinner: Bool
    let isFirstRunner: Bool
    let isSecondRunner: Bool
    
    init(itemName: String,
         itemAddress: String,
         itemDescription: String,
         imageURL: String,
         isWinner: Bool = false,
         isFirstRunner: Bool = false,
         isSecondRunner: Bool = false)
    {
        
        self.itemName = itemName
        self.itemAddress = itemAddress
        self.itemDescription = itemDescription
        self.imageURL = imageURL
        self.isWinner = isWinner
        self.isFirstRunner = isFirstRunner
        self.isSecondRunner = isSecondRunner
    }
}


struct DetailItemFactory{
    
    //These are the array positions of the name/Description/title String in the
    //contentDescription field in the categoryJSON.contentText,
    //when the categoryJSON.contentText is split up with
    //.componentsSeparatedBy "\n"
    
    private enum arrIndexItems: Int{
        case catDescription = 0
        case categoryName = 3
        
        case itemWinnerName = 4
        case itemWinnerAddress = 5
        case itemWinnerDescription = 7
        
        case firstRunnerUpName = 11
        case firstRunnerUpAddress = 12
        case firstRunnerUpDescription = 14
        
        case secondRunnerUpName = 18
        case secondRunnerUpAddress = 19
        case secondRunnerUpDescription = 21
    }
    
    static func createCategoryDetailFromText(categoryItemContentText: String, strHTML: String) -> BOCategoryDetail?{
        
        let arrText = categoryItemContentText.components(separatedBy: "\n")
        
        guard let catDescription = arrText[safe: arrIndexItems.catDescription.rawValue] else{
            print("--!-- MODEL ERROR: CategoryItemDescription unavailable --!-- ")
            return nil
        }
        guard let catName = arrText[safe: arrIndexItems.categoryName.rawValue] else{
            print("--!-- MODEL ERROR: CategoryItemName unavailable --!-- ")
            return nil
        }
        
        return BOCategoryDetail(categoryDescription: catDescription, categoryTitle: catName, arrItems: createDetailItemsFromTextArrays(arrTextContent: arrText, strHTML: strHTML))
    }
    
    //DetailItems are the items contained within ContentItem.Text
    private static func createDetailItemsFromTextArrays(arrTextContent: [String], strHTML: String) -> [BOCategoryDetailItem]{
        
        guard let itemWinnerName = arrTextContent[safe: arrIndexItems.itemWinnerName.rawValue] else{
            print("--!-- MODEL ERROR: categoryDetailItem doesn't have winner --!-- ")
            return []
        }
        guard let itemWinnerAddress = arrTextContent[safe: arrIndexItems.itemWinnerAddress.rawValue] else{
            print("--!-- MODEL ERROR: categoryDetailItem doesn't have winner address --!-- ")
            return []
        }
        guard let itemWinnerDescription = arrTextContent[safe: arrIndexItems.itemWinnerDescription.rawValue] else{
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
                                          isWinner: true)
        var detailItems: [BOCategoryDetailItem] = [winner]
        
        guard let firstRunnerUpName = arrTextContent[safe: arrIndexItems.firstRunnerUpName.rawValue] else{
            print("--!-- MODEL ERROR: First Runner Up Parsing Error Name--!--")
            return detailItems
        }
        guard let firstRunnerUpAddress = arrTextContent[safe: arrIndexItems.firstRunnerUpAddress.rawValue] else{
            print("--!-- MODEL ERROR: First Runner Up Parsing Error Address --!-- ")
            return detailItems
        }
        guard let firstRunnerUpDesc = arrTextContent[safe: arrIndexItems.firstRunnerUpDescription.rawValue] else{
            print("--!-- MODEL ERROR: First Runner Up Parsing Error Description--!-- ")
            return detailItems
        }
        
        let runnerUp = BOCategoryDetailItem(itemName: firstRunnerUpName,
                                                         itemAddress: firstRunnerUpAddress,
                                                         itemDescription: firstRunnerUpDesc,
                                                         imageURL: runnerUpURL,
                                                         isFirstRunner: true)
        
        detailItems.append(runnerUp)
        
        guard let secondRunnerUpName = arrTextContent[safe: arrIndexItems.secondRunnerUpName.rawValue] else{
            print("--!-- MODEL ERROR: Second Runner Up Parsing Error Name --!-- ")
            return detailItems
        }
        guard let secondRunnerUpAddress = arrTextContent[safe: arrIndexItems.secondRunnerUpAddress.rawValue] else{
            print("--!-- MODEL ERROR: Second Runner Up Parsing Address --!-- ")
            return detailItems
        }
        guard let secondRunnerUpDesc = arrTextContent[safe: arrIndexItems.secondRunnerUpDescription.rawValue] else{
            print("--!-- MODEL ERROR: Second Runner Up Parsing Description  --!-- ")
            return detailItems
        }
        
        let secondRunnerUp = BOCategoryDetailItem(itemName: secondRunnerUpName,
                                                               itemAddress: secondRunnerUpAddress,
                                                               itemDescription: secondRunnerUpDesc,
                                                               imageURL: secondRunnerUpURL,
                                                               isSecondRunner: true)
        
        detailItems.append(secondRunnerUp)
        return detailItems
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
        guard let winnerURL = imgURLStrings[safe: arrIndexImgURL.winnerImgURL.rawValue] else{
            print("ERROR: Parsing winnerImgURL failed")
            return []
        }
        
        guard let runnerUp1 = imgURLStrings[safe: arrIndexImgURL.firstRunnerUpImgURL.rawValue] else{
            print("ERROR: Parsing runnerUpImgURL failed")
            return [winnerURL]
        }
        
        guard let runnerUp2 = imgURLStrings[safe: arrIndexImgURL.secondRunnerUpImgURL.rawValue] else{
            print("ERROR: Parsing runnerUpimgURL2 failed")
            return [winnerURL, runnerUp1]
        }
        
        return [winnerURL, runnerUp1, runnerUp2]
    }
}
