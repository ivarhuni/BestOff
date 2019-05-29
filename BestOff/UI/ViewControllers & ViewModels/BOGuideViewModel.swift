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

enum ActivePage{
    case left
    case right
    case swipeScreenNotActive
}

enum ContentType{
    case guides
    case guideDetail
    case reykjavik
    case reykjavikSubCategories
    case iceland
    case favourites
}

class BOGuideViewModel: BOViewModel {
    
    //MARK: Public
    //MARK: Magic number animation/duration constants
    let menuAnimationDuration: Double = 0.5
    let alphaVisible: CGFloat = 1.0
    let alphaInvisible: CGFloat = 0
    
    //MARK: ScreenContentType
    let screenContentType = Observable<ContentType>(.guides)
    
    //MARK: Datasources
    let activeTableDataSource = Observable<UITableViewDataSource?>(nil)
    let activeTableDelegate = Observable<UITableViewDelegate?>(nil)
    
    private let guideListDataSource = Observable<BOCategoryListDataSourceProtocol?>(BOGuideTableDataSource())
    private let guideDetailDataSource = Observable<BOCategoryDetailListProtocol?>(BOGuideDetailTableDataSource())
    private let rvkCategoriesDataSource = Observable<RvkCategoriesDataSource?>(RvkCategoriesDataSource())
    private let subcategoriesListDataSource = Observable<BOSpecificCatWinnersDataSource?>(nil)
    private let favDataSource = Observable<BOFavouritesDataSource>(BOFavouritesDataSource())
    
    let tableDataSourceAnimationDuration:Double = 0.4
    
    //MARK: Menu
    let menuOpen = Observable<Bool>(false)
    
    //MARK: SWIPE
    let activePage = Observable<ActivePage>(.left)

    //MARK: Private properties
    private let disposeBag = DisposeBag()
    
    private var guides = Observable<BOCategoryModel?>(nil)
    private var rvkDrink = Observable<BOCategoryModel?>(nil)
    private var rvkActivities = Observable<BOCategoryModel?>(nil)
    private var rvkShopping = Observable<BOCategoryModel?>(nil)
    private var rvkDining = Observable<BOCategoryModel?>(nil)
    
    private var arrContentHistory: [ContentType] = []

    //RowHeights used in both types of tables
    private let bigCellRowHeight:CGFloat = 310
    
    //MARK: Init
    required init(with contentType: ContentType){
        
        super.init()
        self.screenContentType.value = contentType
        arrContentHistory.append(screenContentType.value)
        createBonding()
    }
}

extension BOGuideViewModel{
    
    func getLastContentType() -> ContentType?{
        
        guard let lastType = arrContentHistory[safe: 1] else { return nil }
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
    
    func setDidPressListDelegateForGuideList(delegater: didPressListDelegate){
        
        self.guideListDataSource.value?.didPressListTableDelegate = delegater
    }
    
    func getGuideListDataSourceNumberOfRows() -> Int{
        guard let myGuideListDataSource = self.guideListDataSource.value else { return 0 }
        return myGuideListDataSource.numberOfRows()
    }
    
    func getGuideDetailListDataSourceNumberOfRows() -> Int{
        guard let myGuideListDataSource = self.guideDetailDataSource.value else { return 0 }
        return myGuideListDataSource.numberOfRows()
    }
}

extension BOGuideViewModel{
    
    func setTableDelegateFor(contentType: ContentType){
        
        switch contentType{
            
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
            
        case .reykjavikSubCategories:
            guard let subCategory = self.subcategoriesListDataSource.value else {
                print("subCategoryListDataSource not set while settings Delegate")
                return
            }
            self.activeTableDelegate.value = subCategory
            
            
        case .iceland:
            print("")
            
        case .favourites:
            
            activeTableDataSource.value = favDataSource.value
            activeTableDelegate.value = favDataSource.value
        }
    }
    
    func setTableDataSourceFor(contentType: ContentType){
        
        switch contentType{
            
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
            
        case .reykjavikSubCategories:
            guard let subCategory = self.subcategoriesListDataSource.value else {
                print("guideListDataSource not set while settings Delegate")
                return
            }
            self.activeTableDataSource.value = subCategory
            
            
        case .iceland:
            print("")
            
        case .favourites:
            print("")
        }
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
            
            if this.shouldChangeDataSourceToGuideList(){
                
                this.activeTableDataSource.value = this.guideListDataSource.value
            }
            
            }.dispose(in: disposeBag)
        
        _ = self.rvkDining.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let catWinnerDSource = this.rvkCategoriesDataSource.value else { return }
            guard let model = model else { return }
            
            catWinnerDSource.setDiningModel(catModel: model)
            catWinnerDSource.takeMeThereVMDelegate = self
        }
        
        _ = self.rvkDrink.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let catWinnerDSource = this.rvkCategoriesDataSource.value else { return }
            guard let model = model else { return }
            catWinnerDSource.setDrinkingModel(catModel: model)
            catWinnerDSource.takeMeThereVMDelegate = self
        }
        
        _ = self.rvkShopping.observeNext{ [weak self] model in
        
            guard let this = self else { return }
            guard let catWinnerDSource = this.rvkCategoriesDataSource.value else { return }
            guard let model = model else { return }
            catWinnerDSource.setShoppingModel(catModel: model)
            catWinnerDSource.takeMeThereVMDelegate = self
        }
        
        _ = self.rvkActivities.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let catWinnerDSource = this.rvkCategoriesDataSource.value else { return }
            guard let model = model else { return }
            catWinnerDSource.setActivitiesModel(catModel: model)
            catWinnerDSource.takeMeThereVMDelegate = self
        }
    }
}

//MARK: DataSource Detail
extension BOGuideViewModel: vmTableViewDelegate{
    
    func tableViewPressedAt(_ index: Int) {
        
        let bigGuideCellIndex = 1
        
        if shouldRespondToTableIndexPress(){
            if index == bigGuideCellIndex { changeDataSourceToFirstDetail() }
        }
    }
    
    func changeDataSourceToDetailWith(item: BOCatItem){
        
        guideDetailDataSource.value = BOGuideDetailTableDataSource(catItem: item)
        screenContentType.value = .guideDetail
    }
    
    private func changeDataSourceToFirstDetail(){
        
        guard let topCellItem = guideListDataSource.value?.categoryModel.value?.items[safe: 0] else {
            
            print("unable to get topcell item")
            return
        }
        
        guideDetailDataSource.value = BOGuideDetailTableDataSource(catItem: topCellItem)
        screenContentType.value = .guideDetail
    }
}


//MARK: Cell button clicked - Take Me There
extension BOGuideViewModel: TakeMeThereProtocol{
    
    func didPressTakeMeThere(type: Endpoint) {
        
        switch type{
            
        case .rvkDining:
            guard let specificCategoryDataSource = BOSpecificCatWinnersDataSource(category: self.rvkDining.value, catTitle: "DINING") else {
                print("no specific category datasource available DINING")
                return
            }
            changeDataSourceToSpecific(categoryDataSource: specificCategoryDataSource)
            
        case .rvkDrink:
            guard let specificCategoryDataSource = BOSpecificCatWinnersDataSource(category: self.rvkDrink.value, catTitle: "DRINKING") else {
                print("no specific category datasource available DRINK")
                return
            }
            changeDataSourceToSpecific(categoryDataSource: specificCategoryDataSource)
            
        case .rvkShopping:
            guard let specificCategoryDataSource = BOSpecificCatWinnersDataSource(category: self.rvkShopping.value, catTitle: "SHOPPING") else {
                print("no specific category datasource available SHOPPING")
                return
            }
            changeDataSourceToSpecific(categoryDataSource: specificCategoryDataSource)
            
        case .rvkActivities:
            guard let specificCategoryDataSource = BOSpecificCatWinnersDataSource(category: self.rvkActivities.value, catTitle: "ACTIVITIES") else {
                print("no specific category datasource available ACTIVITIES")
                return
            }
            changeDataSourceToSpecific(categoryDataSource: specificCategoryDataSource)
            
        default:
            print("default takemethereVCprotocol")
        }
    }
    
    func changeDataSourceToSpecific(categoryDataSource: BOSpecificCatWinnersDataSource){
        
        subcategoriesListDataSource.value = categoryDataSource
        screenContentType.value = .reykjavikSubCategories
    }
}

//Active Page incase swipe is enabled
extension BOGuideViewModel{
    
    func shouldChangeDataSourceToGuideList() -> Bool{
        
        if activeTableDataSource.value == nil { return true }
        if activeTableDataSource.value is BOGuideTableDataSource { return true}
        return false
    }
    
    func shouldSwipeBeEnabled() -> Bool{
        
        if (activeTableDataSource.value is BOGuideTableDataSource) || (activeTableDataSource.value is RvkCategoriesDataSource){
            return true
        }
        
        return false
    }
    
    func shouldRespondToTableIndexPress() -> Bool{
        return (activeTableDataSource.value is BOGuideTableDataSource)
    }
}


//TODO: Candiate for Refactor
//MARK: Networking
extension BOGuideViewModel{
    
    func downloadData(){
        
        getGuides()
        getCategoryWinners()
    }
    
    private func getGuides(){
        
        let categoryNetworkService = BOCategoryService()
        categoryNetworkService.getCategory(.guides) { [weak self] (model, error) in
            
            //Error handling
            guard let this = self else{
                return
            }
            if let nError = error{
                print(nError)
                this.showDataError()
                return
            }
            
            guard let categoryModel = model else {
                this.guides.value = nil
                this.showDataError()
                return
            }
            this.guides.value = categoryModel
        }
    }
    
    private func getCategoryWinners(){
        
        let categoryNetworkService = BOCategoryService()
        
        categoryNetworkService.getCategory(.rvkDrink) { [weak self] (model, error) in
            
            //Error handling
            guard let this = self else{
                return
            }
            if let nError = error{
                print(nError)
                this.showDataError()
                return
            }
            
            guard let categoryModel = model else {
                this.rvkDrink.value = nil
                this.showDataError()
                return
            }
            this.rvkDrink.value = categoryModel
        }
        
        categoryNetworkService.getCategory(.rvkActivities) { [weak self] (model, error) in
            
            //Error handling
            guard let this = self else{
                return
            }
            if let nError = error{
                print(nError)
                this.showDataError()
                return
            }
            
            guard let categoryModel = model else {
                this.rvkActivities.value = nil
                this.showDataError()
                return
            }
            this.rvkActivities.value = categoryModel
        }
        
        categoryNetworkService.getCategory(.rvkDining) { [weak self] (model, error) in
            
            //Error handling
            guard let this = self else{
                return
            }
            if let nError = error{
                print(nError)
                this.showDataError()
                return
            }
            
            guard let categoryModel = model else {
                this.rvkDining.value = nil
                this.showDataError()
                return
            }
            this.rvkDining.value = categoryModel
        }
        
        categoryNetworkService.getCategory(.rvkShopping) { [weak self] (model, error) in
            
            //Error handling
            guard let this = self else{
                return
            }
            if let nError = error{
                print(nError)
                this.showDataError()
                return
            }
            
            guard let categoryModel = model else {
                this.rvkShopping.value = nil
                this.showDataError()
                return
            }
            this.rvkShopping.value = categoryModel
        }
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
        
        case .favourites:
            return "FAVOURITES"
            
        case .guides:
            return "BEST OF REYKJAVÍK"
            
        case .guideDetail:
            return ""
            
        case .reykjavik:
            return "BEST OF REYKJAVÍK"
            
        case .reykjavikSubCategories:
            return "BEST OF REYKJAVÍK"
            
        case .iceland:
            return "BEST OF ICELAND"
            
        }
    }
}

extension BOGuideViewModel{
    
    func setEditDelegateForFavourites(delegate: BOGuideViewController){
        favDataSource.value.editClickedDelegate = delegate
    }
    
    func toggleEditActive(){
        favDataSource.value.isDeleteActive.value = !favDataSource.value.isDeleteActive.value
    }
}
