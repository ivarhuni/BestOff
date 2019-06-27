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

enum DetailScreenType{
    
    case guide
    case bestof
    case event
}

class BOGuideDetailTableDataSource: NSObject, BOCategoryDetailListProtocol{
    
    var catItem = Observable<BOCatItem?>(nil)
    var screenType = DetailScreenType.guide
    var catDetail: BOCategoryDetail?
    
    let constraintedWidth = (UIScreen.main.bounds.width - 2*20)
    let constraintedWidthForWinnerOrRunners = (UIScreen.main.bounds.width - 2*20) - 20
    let textDescFont = UIFont.cellItemText
    let arrIndexWinner = 0
    let arrIndexRunner = 1
    let arrIndexRunnerSecond = 2
    
    let bigImgTopCellIndex = 0
    let txtDescCell = 1
    let redWinnerIndex = 2
    let winnerImgIndex = 3
    let winnerTextIndex = 4
    let redRunnerIndex = 5
    let runnerImgIndex = 6
    let runnerTextIndex = 7
    let redRunnerSecondIndex = 8
    let nextRunnerImgIndex = 9
    let nextRunnerTextIndex = 10
    let runnerHeight: CGFloat = 70
    
    let bigImgCellCategoryHeight:CGFloat = 360.0
    let bigImgCellGuideHeight: CGFloat = 320
    
    weak var favDelegate: FavAndShareDelegate?
    
    convenience init(catItem: BOCatItem, type: DetailScreenType = .guide, detailItem: BOCategoryDetail? = nil){
        self.init()
        self.catItem.value = catItem
        self.screenType = type
        
        if detailItem != nil{
            self.catDetail = detailItem
            self.screenType = .bestof
        }
    }
    
    func setCatDetail(catDetail: BOCategoryDetail){
        self.catDetail = catDetail
    }
    
    func setCatItemTo(item: BOCatItem) {
        self.catItem.value = item
    }
    
    func setFavDelegate(delegate: FavAndShareDelegate){
        self.favDelegate = delegate
    }
}

extension BOGuideDetailTableDataSource{
    
    func numberOfRows() -> Int {
        
        let imgCell = 1
        let txtDescription = 1
        
        if self.screenType == .guide{
            
            guard let item = self.catItem.value else { return 0 }
            guard let countItems = item.detailItem?.arrItems.count else { return 0 }
            
            return countItems*2 + imgCell + txtDescription
        }
        
        if self.screenType == .event {
            
            return imgCell + txtDescription
        }
        
        guard let countItems = self.catDetail?.arrItems.count else {
            
            print("returning 0 count items in boguidedetailtabledatasource")
            return 0
        }
        let oneItemIsTwoCells = 2
        let winnerRedBanner = 1
        let redRunnerUpBanner = 1
        //Winner Only
        if countItems == 1 {
            return imgCell + txtDescription + oneItemIsTwoCells + winnerRedBanner
        }
        //Winner + 1 runner up
        if countItems == 2 {
            return imgCell + txtDescription + oneItemIsTwoCells*2 + redRunnerUpBanner + winnerRedBanner
        }
        
        //Winner + 2 runner ups
        return imgCell + txtDescription + oneItemIsTwoCells*3 + redRunnerUpBanner*2 + winnerRedBanner
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func cellForRowAtIndexPathIn(myTableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let topBigImgCellIndex = 0
        let contentTextDescIndex = 1
        let firstImgRegularCellIndex = 2
        let firstTextRegularCellIndex = 3
        
        if indexPath.row == topBigImgCellIndex{
            
            return getTopCellForTableView(tableView: myTableView)
        }
        if indexPath.row == contentTextDescIndex{
            
            return getDescriptionCellForTableView(tableview: myTableView)
        }
        
        if screenType == .guide{
            
            if indexPath.row == firstImgRegularCellIndex{
                return getFirstImgCellIn(tableView: myTableView)
            }
            
            if indexPath.row == firstTextRegularCellIndex{
                return getFirstTxtCellIn(tableView: myTableView)
            }
            
            //If the indexRow is even, then we display an ImageCell
            //otherwise we are displaying a text cell for the ImageCell's text
            return getNextCellFor(myTableView:myTableView, atIndexPath: indexPath)
        }
        
        if indexPath.row == redWinnerIndex{
            
            let redWinnerCell = myTableView.dequeueReusableCell(withIdentifier: RunnerUpCell.reuseIdentifier()) as! RunnerUpCell
            guard let winnerOrRunnerText = catDetail?.arrItems.first?.categoryWinnerOrRunnerTitle else {
                
                print("no winner or runner text")
                return UITableViewCell()
            }
            redWinnerCell.setupWithText(text: winnerOrRunnerText)
            return redWinnerCell
        }
        
        if indexPath.row == redRunnerIndex{
            
            let redRunnerCell = myTableView.dequeueReusableCell(withIdentifier: RunnerUpCell.reuseIdentifier()) as! RunnerUpCell
            guard let winnerOrRunnerText = catDetail?.arrItems[safe: 1]?.categoryWinnerOrRunnerTitle else {
                
                print("no winner or runner text RUNNER UP")
                return UITableViewCell()
            }
            redRunnerCell.setupWithText(text: winnerOrRunnerText)
            return redRunnerCell
        }
        
        if indexPath.row == redRunnerSecondIndex{
            let redRunnerCell = myTableView.dequeueReusableCell(withIdentifier: RunnerUpCell.reuseIdentifier()) as! RunnerUpCell
            guard let winnerOrRunnerText = catDetail?.arrItems[safe: 2]?.categoryWinnerOrRunnerTitle else {
                
                print("no winner or runner text RUNNER UP")
                return UITableViewCell()
            }
            redRunnerCell.setupWithText(text: winnerOrRunnerText)
            return redRunnerCell
        }
        
        if indexPath.row == winnerImgIndex{
            guard let detailItemWinner = catDetail?.arrItems[safe: arrIndexWinner] else {
                print("detailitemwinnerImg not available in categorydetail")
                return UITableViewCell()
            }
            let topCell = myTableView.dequeueReusableCell(withIdentifier: TopGuideCell.reuseIdentifier()) as! TopGuideCell
            topCell.setupForCategoryDetailItem(detailItem: detailItemWinner)
            if topCell.cornerRoundType != .roundTop{
                topCell.cornerRoundType = .roundTop
                topCell.setNeedsLayout()
                topCell.contentView.setNeedsLayout()
            }
            return topCell
        }
        if indexPath.row == winnerTextIndex{
            guard let detailItemWinner = catDetail?.arrItems[safe: arrIndexWinner] else {
                print("detailitemwinnerTxt not available in categorydetail")
                return UITableViewCell()
            }
            let txtCell = myTableView.dequeueReusableCell(withIdentifier: BOCatItemTextDescriptionCell.reuseIdentifier()) as! BOCatItemTextDescriptionCell
            txtCell.changeLeadingConstraintToCatDetail()
            txtCell.setText(text: detailItemWinner.itemDescription)
            if txtCell.cornerRoundType != .roundBot{
                txtCell.cornerRoundType = .roundBot
                txtCell.setNeedsLayout()
                txtCell.contentView.setNeedsLayout()
            }
            
            return txtCell
        }
        if indexPath.row == runnerImgIndex{
            guard let detailItemRunnerUp = catDetail?.arrItems[safe: arrIndexRunner] else {
                print("detailItemRunnerUp not available in categorydetail")
                return UITableViewCell()
            }
            let topCell = myTableView.dequeueReusableCell(withIdentifier: TopGuideCell.reuseIdentifier()) as! TopGuideCell
            topCell.setupForCategoryDetailItem(detailItem: detailItemRunnerUp)
            if topCell.cornerRoundType != .roundTop{
                topCell.cornerRoundType = .roundTop
                topCell.setNeedsLayout()
                topCell.contentView.setNeedsLayout()
            }

            return topCell
        }
        if indexPath.row == runnerTextIndex{
            guard let detailItemRunnerUp = catDetail?.arrItems[safe: arrIndexRunner] else {
                print("detailItemRunnerUp not available in categorydetail")
                return UITableViewCell()
            }
            let txtCell = myTableView.dequeueReusableCell(withIdentifier: BOCatItemTextDescriptionCell.reuseIdentifier()) as! BOCatItemTextDescriptionCell
            txtCell.setText(text: detailItemRunnerUp.itemDescription)
            txtCell.changeLeadingConstraintToCatDetail()
            if txtCell.cornerRoundType != .roundBot{
                txtCell.cornerRoundType = .roundBot
                txtCell.setNeedsLayout()
                txtCell.contentView.setNeedsLayout()
            }
            return txtCell
        }
        
        if indexPath.row == nextRunnerImgIndex{
            guard let detailItemRunnerUpSecond = catDetail?.arrItems[safe: arrIndexRunnerSecond] else {
                print("detailItemRunnerUp not available in categorydetail")
                return UITableViewCell()
            }
            let topCell = myTableView.dequeueReusableCell(withIdentifier: TopGuideCell.reuseIdentifier()) as! TopGuideCell
            topCell.setupForCategoryDetailItem(detailItem: detailItemRunnerUpSecond)
            if topCell.cornerRoundType != .roundTop{
                topCell.cornerRoundType = .roundTop
                topCell.setNeedsLayout()
                topCell.contentView.setNeedsLayout()
            }
            return topCell
        }
        if indexPath.row == nextRunnerTextIndex{
            guard let detailItemRunnerUpSecond = catDetail?.arrItems[safe: arrIndexRunnerSecond] else {
                print("detailItemRunnerUp not available in categorydetail")
                return UITableViewCell()
            }
            let txtCell = myTableView.dequeueReusableCell(withIdentifier: BOCatItemTextDescriptionCell.reuseIdentifier()) as! BOCatItemTextDescriptionCell
            txtCell.setText(text: detailItemRunnerUpSecond.itemDescription)
            txtCell.changeLeadingConstraintToCatDetail()
            if txtCell.cornerRoundType != .roundBot{
                txtCell.cornerRoundType = .roundBot
                txtCell.setNeedsLayout()
                txtCell.contentView.setNeedsLayout()
            }
            return txtCell
        }
        print("returning UITableViewCell in BOGuideDetail")
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRowAtIndexPathIn(myTableView: tableView, indexPath: indexPath)
    }
}

extension BOGuideDetailTableDataSource{
    
    private func getNextCellFor(myTableView: UITableView, atIndexPath: IndexPath) -> UITableViewCell{
        
        if screenType == .guide{
            
            if atIndexPath.row.isEven(){
                
                guard let nextItem = catItem.value?.detailItem?.arrItems[safe: (atIndexPath.row)/2 - 1 ] else {
                    
                    print("nextcell returning default cell, img")
                    return UITableViewCell()
                }
                let bigImgCell = myTableView.dequeueReusableCell(withIdentifier: GuideItemCell.reuseIdentifier()) as! GuideItemCell
                bigImgCell.setupWithGuide(guide: nextItem)
                return bigImgCell
            }
            
            guard let nextItem = catItem.value?.detailItem?.arrItems[safe: (atIndexPath.row/2) - 1 ] else {
                
                print("nextcell returning default cell, img, text")
                return UITableViewCell()
            }
            
            let txtCell = myTableView.dequeueReusableCell(withIdentifier: BOCatItemTextDescriptionCell.reuseIdentifier()) as! BOCatItemTextDescriptionCell
            txtCell.setText(text: nextItem.itemDescription)
            return txtCell
        }
        
        return UITableViewCell()
        
    }
    
    private func getFirstTxtCellIn(tableView: UITableView) -> UITableViewCell{
        
        guard let nextItem = catItem.value?.detailItem?.arrItems[safe: 0] else {
            
            print("no text for for item BOGUIDEDETAILTABLEDATASOURCE")
            return UITableViewCell()
        }
        let txtCell = tableView.dequeueReusableCell(withIdentifier: BOCatItemTextDescriptionCell.reuseIdentifier()) as! BOCatItemTextDescriptionCell
        txtCell.setText(text: nextItem.itemDescription)
        if screenType == .bestof{
            txtCell.cornerRoundType = .roundBot
            txtCell.setBackgroundForCategory()
        }
        return txtCell
    }
    
    private func getFirstImgCellIn(tableView: UITableView) -> UITableViewCell{
        
        guard let nextItem = catItem.value?.detailItem?.arrItems[safe: 0] else {
            
            print("No item for first doubleRow")
            return UITableViewCell()
        }
        let bigImgCell = tableView.dequeueReusableCell(withIdentifier: GuideItemCell.reuseIdentifier()) as! GuideItemCell
        bigImgCell.setupWithGuide(guide: nextItem)
        return bigImgCell
    }
    
    private func getTopCellForTableView(tableView: UITableView, type: DetailScreenType = .guide) -> UITableViewCell{
        
        let topCell = tableView.dequeueReusableCell(withIdentifier: TopGuideCell.reuseIdentifier()) as! TopGuideCell
        topCell.styleForDetail()
        guard let item = catItem.value else {
            return UITableViewCell()
        }
        topCell.setupWith(item: item, forFavourites: true, favDelegate: self)
        
        if screenType == .event{
            topCell.setupForEventDetailWith(item: item)
        }
        if screenType == .guide{
            topCell.hideFavs()
        }
        
        return topCell
    }
    
    private func getDescriptionCellForTableView(tableview: UITableView) -> UITableViewCell{
        
        let txtCell = tableview.dequeueReusableCell(withIdentifier: BOCatItemTextDescriptionCell.reuseIdentifier()) as! BOCatItemTextDescriptionCell
        
        if screenType == .event{
            
            guard let text = catItem.value?.contentText else{
                print("not cat item text for event")
                return UITableViewCell()
            }
            txtCell.setText(text: text)
            txtCell.cornerRoundType = .roundBot
            txtCell.setBackgroundForCategory()
            txtCell.setNeedsLayout()
            txtCell.contentView.setNeedsLayout()
            return txtCell
        }
        
        guard let text = catItem.value?.detailItem?.categoryDescription else {
            
            print("returning tableviewell instead of txtCell for contentTextDescIndex")
            return UITableViewCell()
        }
        txtCell.setText(text: text)
        if screenType == .bestof{
            txtCell.cornerRoundType = .roundBot
            txtCell.setBackgroundForCategory()
            txtCell.setNeedsLayout()
            txtCell.contentView.setNeedsLayout()
        }
        return txtCell
    }
}

extension BOGuideDetailTableDataSource: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if screenType == .guide || screenType == .event{
            
            if indexPath.row == bigImgTopCellIndex{
                return bigImgCellGuideHeight
            }
            if indexPath.row == txtDescCell{
                if screenType == .event{
                    return getHeightForEventText()
                }
                return getHeightForContentText()
            }
            
            //ImageCellHeight, guide or runner up
            if indexPath.row.isEven(){
                return 340
            }
            return getHeightForTxtCellAt(indexPath: indexPath)
        }
        
        if screenType == .bestof{
            
            if indexPath.row == bigImgTopCellIndex{
                return bigImgCellGuideHeight
            }
            if indexPath.row == txtDescCell{
                return getHeightForContentText()
            }
            if indexPath.row == redWinnerIndex{
                return runnerHeight
            }

            if indexPath.row == winnerImgIndex{
                return bigImgCellCategoryHeight
            }
            
            if indexPath.row == winnerTextIndex{
                return getHeightForWinner()
            }
            
            if indexPath.row == redRunnerIndex{
                return runnerHeight
            }
            
            if indexPath.row == runnerImgIndex{
                return bigImgCellCategoryHeight
            }
            
            if indexPath.row == runnerTextIndex{
                return getHeightForRunnerUp()
            }
            
            if indexPath.row == redRunnerSecondIndex{
                return runnerHeight
            }
            
            if indexPath.row == nextRunnerImgIndex{
                return bigImgCellCategoryHeight
            }
            
            if indexPath.row == nextRunnerTextIndex{
                return getHeightForSecondRunnerUp()
            }
        }
        
        return 10
    }
}

extension BOGuideDetailTableDataSource{
    
    private func getHeightForWinner() -> CGFloat{
        
        guard let winnerTxt = catItem.value?.detailItem?.arrItems[safe: arrIndexWinner]?.itemDescription else { return 1 }
        
        return winnerTxt.height(withConstrainedWidth: constraintedWidthForWinnerOrRunners, font: textDescFont)
    }
    
    private func getHeightForRunnerUp() -> CGFloat{
        
        guard let runnerUpTxt = catItem.value?.detailItem?.arrItems[safe: arrIndexRunner]?.itemDescription else { return 1 }
        
        return runnerUpTxt.height(withConstrainedWidth: constraintedWidthForWinnerOrRunners, font: textDescFont)
    }
    
    private func getHeightForSecondRunnerUp() -> CGFloat{
        
        guard let runnerUpSecondTxt = catItem.value?.detailItem?.arrItems[safe: arrIndexRunnerSecond]?.itemDescription else { return 1 }
        
        return runnerUpSecondTxt.height(withConstrainedWidth: constraintedWidthForWinnerOrRunners, font: textDescFont)
    }
    
    private func getHeightForContentText() -> CGFloat{
        
        guard let text = catItem.value?.detailItem?.categoryDescription else { return 1 }
        
        return text.height(withConstrainedWidth: constraintedWidth, font: textDescFont)
    }
    
    private func getHeightForEventText() -> CGFloat{
        
        guard let text = catItem.value?.contentText else {
            print("no text for cat item title")
            return 0
        }
        return text.height(withConstrainedWidth: constraintedWidth, font: textDescFont)
    }
    
    private func getHeightForTxtCellAt(indexPath: IndexPath) -> CGFloat{
        
        let constraintedWidth = UIScreen.main.bounds.width - 2*20
        let textDescFont = UIFont.cellItemText
        let topAndBotMargin:CGFloat = 20
        
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

extension BOGuideDetailTableDataSource: FavAndShareDelegate{
    
    func pressedFavouriteWithItem(catItem: BOCatItem) {
        
        guard let favDeleg = favDelegate else {
            print("favDelegate not set in DetailTableDataSource")
            return
        }
        favDeleg.pressedFavouriteWithItem(catItem: catItem)
        FavouriteManager.addOrRemoveToFavs(item: catItem)
    }
    
    func pressedShareWithItem(catItem: BOCatItem) {
        guard let favDeleg = favDelegate else {
            print("favDelegate not set in DetailTableDataSource")
            return
        }
        favDeleg.pressedShareWithItem(catItem: catItem)
    }
}
