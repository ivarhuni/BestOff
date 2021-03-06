//
//  BOGuideViewModel.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond
import UIKit

enum ContentType{
    case guides
    case guideDetail
    case reykjavik
    case subCategoriesRvk
    case subCategoriesIce
    case iceland
    case favourites
    case categoryDetail
    case events
    case eventsDetail
}

class BOGuideViewModel: BOViewModel {
    
    //MARK: Public
    //MARK: Magic number animation/duration constants
    let menuAnimationDuration: Double = 0.5
    let alphaVisible: CGFloat = 1.0
    let alphaInvisible: CGFloat = 0
    
    let loaderAnimationSpeed = 0.9
    let loaderAlpha = 0.5
    let loaderDissapearDuration = 1.25
    let containerDissapearDuration = 1.5
    let animationDelay:Double = 4
    let viewActivityAlpha:CGFloat = 0.7
    
    let tableDataSourceAnimationDuration:Double = 0.3
    
    var hasLoadedSomethingOtherThanGuide: Bool = false
    
    //Observables
    let screenContentType = Observable<ContentType>(.reykjavik)
    
    let shouldBeAnimating = Observable<Bool>(true)
    
    //MARK: Datasources
    let activeTableDataSource = Observable<UITableViewDataSource?>(nil)
    let activeTableDelegate = Observable<UITableViewDelegate?>(nil)
    
    private let guideListDataSource = Observable<BOCategoryListDataSourceProtocol?>(BOGuideTableDataSource())
    private let eventListDataSource = Observable<BOCategoryListDataSourceProtocol?>(BOGuideTableDataSource())
    
    private let guideDetailDataSource = Observable<BOCategoryDetailListProtocol?>(BOGuideDetailTableDataSource())
    private let eventDetailDataSource = Observable<BOCategoryDetailListProtocol?>(BOGuideDetailTableDataSource())

    private let catDetailDataSource = Observable<BOCategoryDetailListProtocol?>(BOGuideDetailTableDataSource())
    weak var showCatDetailDelegate: ShowCategoryDetailForType?
    
    private let rvkCategoriesDataSource = Observable<RvkAndIcelandDataSource?>(RvkAndIcelandDataSource(with: .reykjavik))
    private let icelandCategoriesDataSource = Observable<RvkAndIcelandDataSource?>(RvkAndIcelandDataSource(with: .iceland))
    
    private let subcategoriesListDataSource = Observable<BOSpecificCatWinnersDataSource?>(nil)
    
    private let favDataSource = Observable<BOFavouritesDataSource>(BOFavouritesDataSource())
    
    //MARK: Menu
    let menuOpen = Observable<Bool>(false)
    
    //MARK: Private properties
    private let disposeBag = DisposeBag()
    
    private var guides = Observable<BOCategoryModel?>(nil)
    private var events = Observable<BOCategoryModel?>(nil)
    private var rvkDrink = Observable<BOCategoryModel?>(nil)
    private var rvkActivities = Observable<BOCategoryModel?>(nil)
    private var rvkShopping = Observable<BOCategoryModel?>(nil)
    private var rvkDining = Observable<BOCategoryModel?>(nil)
    
    var detailCategory = Observable<BOCategoryDetail?>(nil)
    var detailCategoryCatItem = Observable<BOCatItem?>(nil)
    
    private var detailScreenTitle: String = ""
    
    private var iceNorth = Observable<BOCategoryModel?>(nil)
    private var iceEast = Observable<BOCategoryModel?>(nil)
    private var iceWest = Observable<BOCategoryModel?>(nil)
    private var iceSouth = Observable<BOCategoryModel?>(nil)
    private var iceWestFjords = Observable<BOCategoryModel?>(nil)
    private var iceReykjaNes = Observable<BOCategoryModel?>(nil)
    
    private var arrContentHistory: [ContentType] = []
    
    //RowHeights used in both types of tables
    private let bigCellRowHeight:CGFloat = 310
    
    //MARK: Init
    required init(with contentType: ContentType){
        
        super.init()
        self.screenContentType.value = contentType
        catDetailDataSource.value?.screenType = .bestof
        arrContentHistory.append(screenContentType.value)
        favDataSource.value.catDetailDelegate = self
        eventListDataSource.value?.listType = .event
        createBonding()
        
    }
}

extension BOGuideViewModel{
    
    func getDetailScreenTitle() -> String{
        return detailScreenTitle
    }
}

extension BOGuideViewModel: ShowCategoryDetailForType{
    
    func show(categoryDetail: BOCategoryDetail, catItem: BOCatItem, type: Endpoint) {
        
        guard let delegate = showCatDetailDelegate else {
            print("delegate not set for showcatdetaildelegate in viewmodel")
            return
        }
        detailCategoryCatItem.value = catItem
        catDetailDataSource.value?.setCatItemTo(item: catItem)
        catDetailDataSource.value?.setCatDetail(catDetail: categoryDetail)
        setDetailCategoryTxtFromType(type: type)
        delegate.show(categoryDetail: categoryDetail, catItem: catItem, type: type)
    }
    
    private func setDetailCategoryTxtFromType(type: Endpoint){
        detailScreenTitle = BOGuideViewModel.getHeaderTextFrom(type: type)
    }

}

//MARK: History
extension BOGuideViewModel{
    
    func getNextToLastContentType() -> ContentType?{
        
        let count = arrContentHistory.count
        if count < 2 { return nil }
        let nextToLastIndex = count - 2
        
        guard let nextToLastContentType = arrContentHistory[safe: nextToLastIndex] else { return nil }
        return nextToLastContentType
    }
    
    func getLastContentType() -> ContentType?{
        
        guard let lastType = arrContentHistory.last else { return nil }
        return lastType
    }
    
    func addContentTypeToHistory(typeToAdd: ContentType){
        arrContentHistory.append(typeToAdd)
    }
    
    private func popContentType(){
        arrContentHistory.removeFirst()
    }
}

//Datasource help
extension BOGuideViewModel{
    
    func setDidPressListDelegate(delegater: didPressListDelegate){
        
        self.guideListDataSource.value?.didPressListTableDelegate = delegater
    }
    
    func setDidPressEventListDelegate(delegater: didPressListDelegate){
        
        self.eventListDataSource.value?.didPressListTableDelegate = delegater
    }
    
    func setCategoryDetailClickDelegate(delegate: ShowCategoryDetailForType){
        showCatDetailDelegate = delegate
    }
    
    func getGuideListDataSourceNumberOfRows() -> Int{
        guard let myGuideListDataSource = self.guideListDataSource.value else { return 0 }
        return myGuideListDataSource.numberOfRows()
    }
    
    func getEventListDataSourceNumberOfRows() -> Int{
        guard let myGuideListDataSource = self.eventListDataSource.value else { return 0 }
        return myGuideListDataSource.numberOfRows()
    }
}

extension BOGuideViewModel{
    
    func setTableDelegateFor(contentType: ContentType){
        
        switch contentType{
            
        case .eventsDetail:
            guard let eventDetailDelegate = self.eventDetailDataSource.value else {
                
                print("eventDetailDataSource not set while setting delegate in VM")
                return
            }
            self.activeTableDelegate.value = eventDetailDelegate
            
        case .events:
            guard let eventDelegate = self.eventListDataSource.value else {
                print("eventListDataSource not set while settings Delegate")
                return
            }
            self.activeTableDelegate.value = eventDelegate
        
        case .categoryDetail:
            guard let categoryDetailDelegate = self.catDetailDataSource.value else {
                
                print("catDetailDataSource not set while setting delegate in VM")
                return
            }
            self.activeTableDelegate.value = categoryDetailDelegate
            
            
        case .guides:
            guard let guideDelegate = self.guideListDataSource.value else {
                print("guideListDataSource not set while settings Delegate")
                return
            }
            self.activeTableDelegate.value = guideDelegate
            
        case .guideDetail:
            guard let guideDetailDelegate = self.guideDetailDataSource.value else {
                print("guideDetailDataSource not set while settings Delegate")
                return
            }
            self.activeTableDelegate.value = guideDetailDelegate
            
        case .reykjavik:
            guard let rvkDelegate = self.rvkCategoriesDataSource.value else {
                print("RvkListDataSource not set while settings Delegate")
                return
            }
            self.activeTableDelegate.value = rvkDelegate
            
        case .subCategoriesRvk, .subCategoriesIce:
            guard let subCategory = self.subcategoriesListDataSource.value else {
                print("subCategoryListDataSource not set while settings Delegate")
                return
            }
            self.activeTableDelegate.value = subCategory
            
            
        case .iceland:
            guard let iceDelegate = self.icelandCategoriesDataSource.value else {
                print("iceCateDatasource is not set with settings delegate")
                return
            }
            self.activeTableDelegate.value = iceDelegate
            
        case .favourites:
            
            favDataSource.value.updateFavourites()
            activeTableDataSource.value = favDataSource.value
            activeTableDelegate.value = favDataSource.value
        }
    }
    
    func setTableDataSourceFor(contentType: ContentType){
        
        switch contentType{
            
        case .eventsDetail:
            guard let eventDetailDataSource = self.eventDetailDataSource.value else {
                print("eventDetailDatasource not set in VM")
                return
            }
            self.activeTableDataSource.value = eventDetailDataSource
            
        case .events:
            guard let eventDataSource = self.eventListDataSource.value else {
                print("eventListDataSource not set while settings Delegate")
                return
            }
            self.activeTableDataSource.value = eventDataSource
            
        case .categoryDetail:
            guard let catDetailDataSource = self.catDetailDataSource.value else {
                print("catDetailDatasource not set in VM")
                return
            }
            self.activeTableDataSource.value = catDetailDataSource
            
        case .guides:
            guard let guideDataSource = self.guideListDataSource.value else {
                print("guideListDataSource not set while settings Delegate")
                return
            }
            self.activeTableDataSource.value = guideDataSource
            
        case .guideDetail:
            guard let guideDetailDataSource = self.guideDetailDataSource.value else {
                print("guideListDataSource not set while settings Delegate")
                return
            }
            self.activeTableDataSource.value = guideDetailDataSource
            
        case .reykjavik:
            guard let rvkDataSource = self.rvkCategoriesDataSource.value else {
                print("guideListDataSource not set while settings Delegate")
                return
            }
            self.activeTableDataSource.value = rvkDataSource
            
        case .subCategoriesRvk, .subCategoriesIce:
            guard let subCategory = self.subcategoriesListDataSource.value else {
                print("guideListDataSource not set while settings Delegate")
                return
            }
            self.activeTableDataSource.value = subCategory
            
            
        case .iceland:
            guard let iceDataSource = self.icelandCategoriesDataSource.value else {
                print("iceDataSource not set while in settings delegate")
                return
            }
            print("")
            self.activeTableDataSource.value = iceDataSource
            
        case .favourites:
            print("no applicable")
        }
    }
}

extension BOGuideViewModel{
    
    func updateFavourites(){
        favDataSource.value.updateFavourites()
    }
}

//MARK: Databindings
extension BOGuideViewModel{
    
    private func createBonding(){
        
        _ = self.guides.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let dataModel = model else{ print("guides model nil from server"); return }
            guard let guideListdataSource = this.guideListDataSource.value else { print("guideListDataSource not initialized"); return }
            
            guideListdataSource.setDataModel(model: dataModel)

        }
        
        _ = self.events.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let dataModel = model else{ print("event model nil from server"); return }
            guard let eventListdataSource = this.eventListDataSource.value else { print("eventListDataSource not initialized"); return }
            
            eventListdataSource.setDataModel(model: dataModel)
        }
        
        _ = self.rvkDining.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let catWinnerDSource = this.rvkCategoriesDataSource.value else { return }
            guard let model = model else { return }
            
            catWinnerDSource.setCategoryModelAndRandomIdemForDataSourceType(catModel: model, type: .rvkDining)
            catWinnerDSource.takeMeThereVMDelegate = self
            catWinnerDSource.catDetailDelegate = self
            
           
                this.activeTableDataSource.value = catWinnerDSource
                this.activeTableDelegate.value = catWinnerDSource
            
        }
        
        _ = self.rvkDrink.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let catWinnerDSource = this.rvkCategoriesDataSource.value else { return }
            guard let model = model else { return }
            catWinnerDSource.setCategoryModelAndRandomIdemForDataSourceType(catModel: model, type: .rvkDrink)
            catWinnerDSource.takeMeThereVMDelegate = self
            catWinnerDSource.catDetailDelegate = self
            
            
            this.activeTableDataSource.value = catWinnerDSource
            this.activeTableDelegate.value = catWinnerDSource
        }
        
        _ = self.rvkShopping.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let catWinnerDSource = this.rvkCategoriesDataSource.value else { return }
            guard let model = model else { return }
            catWinnerDSource.setCategoryModelAndRandomIdemForDataSourceType(catModel: model, type: .rvkShopping)
            catWinnerDSource.takeMeThereVMDelegate = self
            catWinnerDSource.catDetailDelegate = self
            
  
                this.activeTableDataSource.value = catWinnerDSource
                this.activeTableDelegate.value = catWinnerDSource
            
        }
        
        _ = self.rvkActivities.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let catWinnerDSource = this.rvkCategoriesDataSource.value else { return }
            guard let model = model else { return }
            catWinnerDSource.setCategoryModelAndRandomIdemForDataSourceType(catModel: model, type: .rvkActivities)
            catWinnerDSource.takeMeThereVMDelegate = self
            catWinnerDSource.catDetailDelegate = self
            
           
                this.activeTableDataSource.value = catWinnerDSource
                this.activeTableDelegate.value = catWinnerDSource
            
        }
        
        _ = self.iceWest.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let catWinnerDSource = this.icelandCategoriesDataSource.value else { return }
            guard let model = model else { return }
            catWinnerDSource.setCategoryModelAndRandomIdemForDataSourceType(catModel: model, type: .west)
            catWinnerDSource.takeMeThereVMDelegate = self
            catWinnerDSource.catDetailDelegate = self
        }
        
        _ = self.iceNorth.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let catWinnerDSource = this.icelandCategoriesDataSource.value else { return }
            guard let model = model else { return }
            catWinnerDSource.setCategoryModelAndRandomIdemForDataSourceType(catModel: model, type: .north)
            catWinnerDSource.takeMeThereVMDelegate = self
            catWinnerDSource.catDetailDelegate = self
        }
        
        _ = self.iceEast.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let catWinnerDSource = this.icelandCategoriesDataSource.value else { return }
            guard let model = model else { return }
            catWinnerDSource.setCategoryModelAndRandomIdemForDataSourceType(catModel: model, type: .east)
            catWinnerDSource.takeMeThereVMDelegate = self
            catWinnerDSource.catDetailDelegate = self
        }
        
        _ = self.iceSouth.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let catWinnerDSource = this.icelandCategoriesDataSource.value else { return }
            guard let model = model else { return }
            catWinnerDSource.setCategoryModelAndRandomIdemForDataSourceType(catModel: model, type: .south)
            catWinnerDSource.takeMeThereVMDelegate = self
            catWinnerDSource.catDetailDelegate = self
        }
        
        _ = self.iceWestFjords.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let catWinnerDSource = this.icelandCategoriesDataSource.value else { return }
            guard let model = model else { return }
            catWinnerDSource.setCategoryModelAndRandomIdemForDataSourceType(catModel: model, type: .westfjords)
            catWinnerDSource.takeMeThereVMDelegate = self
            catWinnerDSource.catDetailDelegate = self
        }
        
        _ = self.iceReykjaNes.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let catWinnerDSource = this.icelandCategoriesDataSource.value else { return }
            guard let model = model else { return }
            catWinnerDSource.setCategoryModelAndRandomIdemForDataSourceType(catModel: model, type: .reykjanes)
            catWinnerDSource.takeMeThereVMDelegate = self
            catWinnerDSource.catDetailDelegate = self
        }
    }
}

//MARK: DataSource Detail
extension BOGuideViewModel: vmTableViewDelegate{
    
    func tableViewPressedAt(_ index: Int) {
        
        let bigGuideCellIndex = 1
        
        if screenContentType.value == .events{
            changeDataSourceToFirstEvent()
            print("first event")
            return
        }
        
        //TODO: FIX FOR EVENTS
        if shouldRespondToTableIndexPress(){
            (index == bigGuideCellIndex) ? changeDataSourceToFirstDetail() : print("nothing")
        }
    }
    
    func changeDataSourceToDetailWith(item: BOCatItem){
        
        if screenContentType.value == .guides{
            guideDetailDataSource.value = BOGuideDetailTableDataSource(catItem: item)
            screenContentType.value = .guideDetail
        }
        if screenContentType.value == .events || screenContentType.value == .eventsDetail{
            changeDataSourceToEventWith(item: item)
        }
    }
    
    func changeDataSourceToEventWith(item: BOCatItem){
        
        eventDetailDataSource.value = BOGuideDetailTableDataSource(catItem: item)
        eventDetailDataSource.value?.screenType = .event
        screenContentType.value = .eventsDetail
    }
    
    func changeDataSourceToFirstEvent(){
        
        guard let topCellItem = eventListDataSource.value?.categoryModel.value?.items[safe: 0] else {
            
            print("unable to get topcell item events")
            return
        }
        detailScreenTitle = "Events"
        eventDetailDataSource.value = BOGuideDetailTableDataSource(catItem: topCellItem)
        eventDetailDataSource.value?.screenType = .event
        screenContentType.value = .eventsDetail
    }
    
    private func changeDataSourceToFirstDetail(){
        
        //TODO: FIX FOR EVENTS
        guard let topCellItem = guideListDataSource.value?.categoryModel.value?.items[safe: 0] else {
            
            print("unable to get topcell item")
            return
        }
        
        screenContentType.value = .guideDetail
        guideDetailDataSource.value = BOGuideDetailTableDataSource(catItem: topCellItem)
    }
}


//MARK: Cell button clicked - Take Me There
extension BOGuideViewModel: TakeMeThereProtocol{
    
    func didPressTakeMeThere(type: Endpoint) {
        
        switch type{
            
        case .rvkDining:
            guard let specificCategoryDataSource = BOSpecificCatWinnersDataSource(category: self.rvkDining.value, catTitle: "Dining") else {
                print("no specific category datasource available DINING")
                return
            }
            changeDataSourceToSpecific(categoryDataSource: specificCategoryDataSource)
            
        case .rvkDrink:
            guard let specificCategoryDataSource = BOSpecificCatWinnersDataSource(category: self.rvkDrink.value, catTitle: "Drinking") else {
                print("no specific category datasource available DRINK")
                return
            }
            changeDataSourceToSpecific(categoryDataSource: specificCategoryDataSource)
            
        case .rvkShopping:
            guard let specificCategoryDataSource = BOSpecificCatWinnersDataSource(category: self.rvkShopping.value, catTitle: "Shopping") else {
                print("no specific category datasource available SHOPPING")
                return
            }
            changeDataSourceToSpecific(categoryDataSource: specificCategoryDataSource)
            
        case .rvkActivities:
            guard let specificCategoryDataSource = BOSpecificCatWinnersDataSource(category: self.rvkActivities.value, catTitle: "Activities") else {
                print("no specific category datasource available ACTIVITIES")
                return
            }
            changeDataSourceToSpecific(categoryDataSource: specificCategoryDataSource)
            
        case .guides, .events:
            print ("not applicable")
            
        case .north:
            guard let specificCategoryDataSource = BOSpecificCatWinnersDataSource(category: self.iceNorth.value, catTitle: "North") else {
                print("no specific category datasource available NORTH")
                return
            }
            changeDataSourceToSpecific(categoryDataSource: specificCategoryDataSource, location: .iceland)
            
        case .east:
            guard let specificCategoryDataSource = BOSpecificCatWinnersDataSource(category: self.iceEast.value, catTitle: "East") else {
                print("no specific category datasource available EAST")
                return
            }
            changeDataSourceToSpecific(categoryDataSource: specificCategoryDataSource, location: .iceland)
            
        case .westfjords:
            guard let specificCategoryDataSource = BOSpecificCatWinnersDataSource(category: self.iceWestFjords.value, catTitle: "Westfjords") else {
                print("no specific category datasource available WESTFJORDS")
                return
            }
            changeDataSourceToSpecific(categoryDataSource: specificCategoryDataSource, location: .iceland)
            
        case .south:
            guard let specificCategoryDataSource = BOSpecificCatWinnersDataSource(category: self.iceSouth.value, catTitle: "South") else {
                print("no specific category datasource available SOUTH")
                return
            }
            changeDataSourceToSpecific(categoryDataSource: specificCategoryDataSource, location: .iceland)
            
        case .west:
            guard let specificCategoryDataSource = BOSpecificCatWinnersDataSource(category: self.iceWest.value, catTitle: "West") else {
                print("no specific category datasource available WEST")
                return
            }
            changeDataSourceToSpecific(categoryDataSource: specificCategoryDataSource, location: .iceland)
            
        case .reykjanes:
            guard let specificCategoryDataSource = BOSpecificCatWinnersDataSource(category: self.iceReykjaNes.value, catTitle: "Reykjanes") else {
                print("no specific category datasource available REYKJANES")
                return
            }
            changeDataSourceToSpecific(categoryDataSource: specificCategoryDataSource, location: .iceland)
        }
    }
    
    private func changeDataSourceToSpecific(categoryDataSource: BOSpecificCatWinnersDataSource, location: LocationDataSource = .reykjavik){
        
        if location == .iceland{
            screenContentType.value = .subCategoriesIce
        }else{
            screenContentType.value = .subCategoriesRvk
        }
        subcategoriesListDataSource.value = categoryDataSource
        subcategoriesListDataSource.value?.catDetailDelegate = self
    }
}

//Active Page incase swipe is enabled
extension BOGuideViewModel{
    
    func shouldChangeDataSourceToGuideList() -> Bool{
        
        if activeTableDataSource.value == nil { return true }
        if activeTableDataSource.value is BOGuideTableDataSource { return true }
        return false
    }
    
    func shouldChangeDataSourceToReykjavik() -> Bool{
        
        if activeTableDataSource.value == nil { return true }
        return false
    }
    
    func shouldSwipeBeEnabled() -> Bool{
        
        if (screenContentType.value == .guides) || (screenContentType.value == .reykjavik){
            return true
        }
        
        return false
    }
    
    func shouldRespondToTableIndexPress() -> Bool{
        return (activeTableDataSource.value is BOGuideTableDataSource)
    }
}

extension BOGuideViewModel{
    
    func getHeaderDetailTxtFromSubCategory() -> String{
        
        guard let category = self.subcategoriesListDataSource.value else { return "" }
        return category.catTitle
    }
}

extension BOGuideViewModel{
    
    func getTextForScreenType() -> String{
        
        switch screenContentType.value {
            
        case .categoryDetail, .eventsDetail:
            print("not applicable")
            return ""
            
        case .favourites:
            return "Favourites"
            
        case .guides:
            return "BEST OF REYKJAVÍK"
        case .events:
            return "Events"
            
        case .guideDetail:
            return ""
            
        case .reykjavik:
            return "BEST OF REYKJAVÍK"
            
        case .subCategoriesRvk:
            return "BEST OF REYKJAVÍK"
        
        case .subCategoriesIce:
            return "BEST OF ICELAND"
        case .iceland:
            return "BEST OF ICELAND"
            
        }
    }
    
    static func getHeaderTextFrom(type: Endpoint) -> String{
        
        switch type{
        case .rvkDrink:
            return "Drinking"
            
        case .events:
            return "Events"
        case .rvkActivities:
            return "Activities"
            
        case .rvkShopping:
            return "Shopping"
            
        case .rvkDining:
            return "Dining"
            
        case .guides:
            return "Guides"
            
        case .north:
            return "North"
            
        case .east:
            return "East"
            
        case .westfjords:
            return "Westfjords"
            
        case .south:
            return "South"
            
        case .west:
            return "West"
            
        case .reykjanes:
            return "Reykjanes"
        }
    }
}

extension BOGuideViewModel{
    
    func setEditDelegateForFavourites(delegate: BOGuideViewController){
        favDataSource.value.editClickedDelegate = delegate
    }
    
    func setFavouriteDelegateForFavourites(delegate: BOGuideViewController){
        favDataSource.value.deleteDelegate = delegate
    }
    
    func setFavouriteDelegateForDetailScreens(delegate: FavAndShareDelegate){
        if let guideDetailDataSource = guideDetailDataSource.value{
            guideDetailDataSource.favDelegate = delegate
        }
        if let catDetailDataSource = catDetailDataSource.value{
            catDetailDataSource.favDelegate = delegate
        }
    }
    
    func toggleEditActive(){
        favDataSource.value.isDeleteActive.value = !favDataSource.value.isDeleteActive.value
    }
}

extension BOGuideViewModel{
    
    func getTableViewAnimationFor(screenContentType: ContentType) -> UITableView.RowAnimation{
        
        switch screenContentType {
            
        case .guides:
            
            guard let lastContentType = getLastContentType() else {
                
                return .left
            }
            
            guard let nextToLastContentType = getNextToLastContentType() else {
                return .fade
            }
            
            if lastContentType == .guides {
                
                if nextToLastContentType == .reykjavik { return .left }
                
                return .fade
            }
            if lastContentType == .guideDetail {
                
                return .fade
            }
            
            if hasLoadedSomethingOtherThanGuide{
                return .right
            }
            
            return .fade
            
        case .guideDetail, .categoryDetail, .eventsDetail:
            print("fade detailscreen")
            return .fade
        case .reykjavik:
            
            guard let lastContentType = getLastContentType() else {
                return .none
            }
            if lastContentType == .reykjavik {
                return .right
            }
            
            guard let nextToLastScreen = getNextToLastContentType() else {
                return .left
            }
            if nextToLastScreen == .subCategoriesRvk {
                return .fade
            }
            return .right
            
        case .subCategoriesRvk, .subCategoriesIce:
            print("automatic subcategories")
            return .automatic
        case .iceland:
            print("fade iceland")
            return .fade
        case .events:
            return .fade
        case .favourites:
            print("favourites automatic")
            return .automatic
        }
    }
}

extension BOGuideViewModel{
    
    static func getRoundedCornerFor(screenContentType: ContentType) -> [UIRectCorner]{
        
        switch screenContentType {
        case .reykjavik, .events:
            return [.topLeft]
        case .guides:
            return [.topRight]
        default:
            return []
        }
    }
}

extension BOGuideViewModel{
    
    func shouldChangeToRvkCategoriesFor(tableView: UITableView) -> Bool{
        
        if tableView.dataSource is BOGuideDetailTableDataSource{
            print("not changing datasource!!")
            return false
        }
        return true
    }
    
    func shouldChangeToIceCategoriesFor(tableView: UITableView) -> Bool{
        
        if tableView.dataSource is BOGuideDetailTableDataSource{
            print("not changing datasource!!")
            return false
        }
        return true
    }
}


extension BOGuideViewModel{
    
    func createCatModelFromEventModel(events: [Event]){
        
        var fakeCatModel = BOCategoryModel.init(descriptionField: "", feedUrl: "", homePageUrl: "", items: [], title: "", userComment: "", version: "", type: .rvkDrink, imageList: nil)
        
        fakeCatModel.items = EventHelper.createCatModelFromEventModel(events: events)
        
        self.events.value = fakeCatModel
    }
}

//MARK: Networking, could use a refactor
extension BOGuideViewModel{
    
    func downloadData(){
        
        getGuides()
        getCategoryWinnersRvk()
        getCategoryWinnersIce()
        getEvents()
    }
    
    private func getEvents(){
        
        let eventService = EventService()
        eventService.getEvents{ [weak self] result in
    
            
            if let events = result.model{
                guard let this = self else { return }
                this.createCatModelFromEventModel(events: events.eventList)
            }
        }
    }
    
    private func getGuides(){
       getCategoryWinnersFor(endpointType: .guides)
    }
    
    private func getCategoryWinnersRvk(){
        
        getCategoryWinnersFor(endpointType: .rvkDrink)
        getCategoryWinnersFor(endpointType: .rvkDining)
        getCategoryWinnersFor(endpointType: .rvkActivities)
        getCategoryWinnersFor(endpointType: .rvkShopping)
    }
    
    private func getCategoryWinnersIce(){
        
        getCategoryWinnersFor(endpointType: .north)
        getCategoryWinnersFor(endpointType: .south)
        getCategoryWinnersFor(endpointType: .east)
        getCategoryWinnersFor(endpointType: .west)
        getCategoryWinnersFor(endpointType: .westfjords)
        getCategoryWinnersFor(endpointType: .reykjanes)
    }
    
    private func getCategoryWinnersFor(endpointType: Endpoint){
        
        let categoryNetworkService = BOCategoryService()
        
        categoryNetworkService.getCategory(endpointType) { [weak self] (model, error) in
            
            //Error handling
            guard let this = self else{
                return
            }
            
            if let nError = error{
                print(nError)
                this.showDataError()
                return
            }
            
            guard var categoryModel = model else {
                this.setDataModelFromCallback(from: endpointType, model: nil)
                this.showDataError()
                return
            }
            categoryModel.setType(type: endpointType)
            
            this.setDataModelFromCallback(from: endpointType, model: categoryModel)
        }
    }
}

extension BOGuideViewModel{
    
    private func setDataModelFromCallback(from endpoint: Endpoint, model: BOCategoryModel?){
        
        guard model != nil else { return }
        
        switch endpoint{
        case .events:
            print("not applicable")
        case .rvkDrink:
            self.rvkDrink.value = model
            
        case .rvkActivities:
            self.rvkActivities.value = model
            
        case .rvkShopping:
            self.rvkShopping.value = model
            
        case .rvkDining:
            self.rvkDining.value = model
            
        case .guides:
            self.guides.value = model
            
        case .north:
            self.iceNorth.value = model
            
        case .east:
            self.iceEast.value = model
            
        case .westfjords:
            self.iceWestFjords.value = model
            
        case .south:
            self.iceSouth.value = model
            
        case .west:
            self.iceWest.value = model
            
        case .reykjanes:
            self.iceReykjaNes.value = model
        }
    }
}
