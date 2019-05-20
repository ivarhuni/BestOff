//
//  BOGuideDetailTableDataSource.swift
//  BestOff
//
//  Created by Ivar Johannesson on 15/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

class BOGuideDetailTableDataSource: NSObject, BOCategoryDetailListProtocol{
    
    
    var catItem = Observable<BOCatItem?>(nil)
    
    //RowHeights used in both types of tables
    let bigCellRowHeight:CGFloat = 310
    
    convenience init(catItem: BOCatItem){
        self.init()
        self.catItem.value = catItem
    }
    
    let topBigImgCellIndex = 0
    let contentTextDescIndex = 1
    
    func setCatItemTo(item: BOCatItem) {
        self.catItem.value = item
    }
}

extension BOGuideDetailTableDataSource{
    
    func numberOfRows() -> Int {
        
        guard let item = self.catItem.value else { return 0 }
        guard let countItems = item.detailItem?.arrItems.count else { return 0 }
        
        let imgCell = 1
        let txtDescription = 1
        
        //each small item has two rows, hence *2
        print("returning NumberOfRows: ")
        print(countItems*2 + imgCell + txtDescription)
        return countItems*2 + imgCell + txtDescription
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func cellForRowAtIndexPathIn(myTableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == topBigImgCellIndex{
            
            let topCell = myTableView.dequeueReusableCell(withIdentifier: TopGuideCell.reuseIdentifier()) as! TopGuideCell
            guard let item = catItem.value else {
                
                //print("returning UITableViewCell instead of TopCell")
                return UITableViewCell()
            }
            topCell.setupWith(item: item)
            topCell.styleForDetail()
            return topCell
        }
        if indexPath.row == contentTextDescIndex{
            
            let txtCell = myTableView.dequeueReusableCell(withIdentifier: BOCatItemTextDescriptionCell.reuseIdentifier()) as! BOCatItemTextDescriptionCell
            guard let text = catItem.value?.detailItem?.categoryDescription else {
                
                //print("returning tableviewell instead of txtCell for contentTextDescIndex")
                return UITableViewCell()
            }
            txtCell.setText(text: text)
            return txtCell
        }
        
        //If the indexRow is even, then we display an ImageCell
        //otherwise we are displaying a text cell for the ImageCell's text
        if indexPath.row.isEven(){
            
            guard let nextItem = catItem.value?.detailItem?.arrItems[safe: (indexPath.row)/2 - 1 ] else {
                
                return UITableViewCell()
            }
            let bigImgCell = myTableView.dequeueReusableCell(withIdentifier: GuideItemCell.reuseIdentifier()) as! GuideItemCell
            bigImgCell.setupWithGuide(guide: nextItem)
            return bigImgCell
        }
        
        if indexPath.row == 3{
            
            guard let nextItem = catItem.value?.detailItem?.arrItems[safe: (indexPath.row)/2 - 1 ] else {
                
                print("no item")
                return UITableViewCell()
            }
            let txtCell = myTableView.dequeueReusableCell(withIdentifier: BOCatItemTextDescriptionCell.reuseIdentifier()) as! BOCatItemTextDescriptionCell
            txtCell.setText(text: nextItem.itemDescription)
            return txtCell
        }
        
        guard let nextItem = catItem.value?.detailItem?.arrItems[safe: (indexPath.row)/2 - 2 ] else {
            
            print("no item")
            return UITableViewCell()
        }
        
        let txtCell = myTableView.dequeueReusableCell(withIdentifier: BOCatItemTextDescriptionCell.reuseIdentifier()) as! BOCatItemTextDescriptionCell
        txtCell.setText(text: nextItem.itemDescription)
        return txtCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRowAtIndexPathIn(myTableView: tableView, indexPath: indexPath)
    }
}

extension BOGuideDetailTableDataSource: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let bigImgTopCellIndex = 0
        let txtDescCell = 1
        // let txtDescCellHeight =
        
        if indexPath.row == bigImgTopCellIndex{
            return bigCellRowHeight
        }
        if indexPath.row == txtDescCell{
            return getHeightForContentText()
        }
        if indexPath.row.isEven(){
            return 340
        }
        return getHeightForTxtCellAt(indexPath: indexPath)
    }
}

extension BOGuideDetailTableDataSource{
    
    func getHeightForContentText() -> CGFloat{
        
        guard let text = catItem.value?.detailItem?.categoryDescription else { return 1 }
        
        //20pt margin left and right
        let constraintedWidth = UIScreen.main.bounds.width - 2*20
        let textDescFont = UIFont.cellItemText
        
        return text.height(withConstrainedWidth: constraintedWidth, font: textDescFont)
    }
    
    func getHeightForTxtCellAt(indexPath: IndexPath) -> CGFloat{
        
        let constraintedWidth = UIScreen.main.bounds.width - 2*20
        let textDescFont = UIFont.cellItemText
        let topAndBotMargin:CGFloat = 5
        
        if indexPath.row.isEven(){
            
            guard let itemText = catItem.value?.detailItem?.arrItems[safe: (indexPath.row)/2 - 1]?.itemDescription else { return 1 }
            
            return itemText.height(withConstrainedWidth: constraintedWidth, font: textDescFont)
        }
        
        if indexPath.row == 3 {
            
            guard let itemText = catItem.value?.detailItem?.arrItems[safe: (indexPath.row)/2 - 1]?.itemDescription else { return 1 }
            return itemText.height(withConstrainedWidth: constraintedWidth, font: textDescFont) + (2*topAndBotMargin)
        }
        
        guard let itemText = catItem.value?.detailItem?.arrItems[safe: (indexPath.row)/2 - 2]?.itemDescription else { return 1 }
        
        return itemText.height(withConstrainedWidth: constraintedWidth, font: textDescFont) + (2*topAndBotMargin)
    }
}
