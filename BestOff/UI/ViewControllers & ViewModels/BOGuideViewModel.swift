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
}

enum ContentType{
    case guides
    case reykjavik
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
    
    //MARK: Protocol properties
    let guideListDataSource = Observable<BOCategoryListDataSourceProtocol?>(nil)
    let guideDetailDataSource = Observable<BOCategoryDetailListProtocol?>(nil)
    let categoryWinnerListDataSource = Observable<BOCategoryWinnersDataSource?>(nil)
    let subcategoriesListDataSource = Observable<BOSpecificCatWinnersDataSource?>(nil)
    
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

    //RowHeights used in both types of tables
    private let bigCellRowHeight:CGFloat = 310
    
    //MARK: Init
    required init(with contentType: ContentType){
        
        super.init()
        self.guideListDataSource.value = BOGuideTableDataSource()
        self.categoryWinnerListDataSource.value = BOCategoryWinnersDataSource()
        self.screenContentType.value = contentType
        createBonding()
    }
}

//MARK: Databindings
extension BOGuideViewModel{
    
    private func createBonding(){

        _ = self.guides.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let dataModel = model else{ return }
            guard let guideListdataSource = this.guideListDataSource.value else { return }
            
            guideListdataSource.setDataModel(model: dataModel)
        }.dispose(in: disposeBag)
        
        
        
        _ = self.rvkDining.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let catWinnerDSource = this.categoryWinnerListDataSource.value else { return }
            guard let model = model else { return }
            
            catWinnerDSource.setDiningModel(catModel: model)
            catWinnerDSource.takeMeThereVMDelegate = self
        }
        
        _ = self.rvkDrink.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let catWinnerDSource = this.categoryWinnerListDataSource.value else { return }
            guard let model = model else { return }
            catWinnerDSource.setDrinkingModel(catModel: model)
            catWinnerDSource.takeMeThereVMDelegate = self
        }
        
        _ = self.rvkShopping.observeNext{ [weak self] model in
        
            guard let this = self else { return }
            guard let catWinnerDSource = this.categoryWinnerListDataSource.value else { return }
            guard let model = model else { return }
            catWinnerDSource.setShoppingModel(catModel: model)
            catWinnerDSource.takeMeThereVMDelegate = self
        }
        
        _ = self.rvkActivities.observeNext{ [weak self] model in
            
            guard let this = self else { return }
            guard let catWinnerDSource = this.categoryWinnerListDataSource.value else { return }
            guard let model = model else { return }
            catWinnerDSource.setActivitiesModel(catModel: model)
            catWinnerDSource.takeMeThereVMDelegate = self
        }
        
        _ = self.subcategoriesListDataSource.observeNext{ _ in
            
            
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
    }
    
    private func changeDataSourceToFirstDetail(){
        
        guard let topCellItem = guideListDataSource.value?.categoryModel.value?.items[safe: 0] else {
            
            print("unable to get topcell item")
            return
        }
        
        guideDetailDataSource.value = BOGuideDetailTableDataSource(catItem: topCellItem)
    }
    
    private func isDetailDataSourceActive() -> Bool{
        if guideDetailDataSource.value == nil { return false }
        return true
    }
}

//MARK: Default
extension BOGuideViewModel{
    
    
}

extension BOGuideViewModel{
    
    func didPressBackInAppHeader(){
        
        (self.activePage.value == .left) ? changeDataSourceToDefault() : reloadWinners()
    }
    
    func changeDataSourceToDefault(){
        
        guideDetailDataSource.value = nil
    }
    
    func reloadWinners(){
        self.activePage.value = .right
    }
}

//MARK: DataSource CategoryWinnersList
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
        
        self.subcategoriesListDataSource.value = categoryDataSource
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
    
    func setActivePage(page: ActivePage){
        self.activePage.value = page
    }
    
    func shouldRefreshTableWithNewCategoryWinner() -> Bool{
        return activePage.value == .right
    }
    
    func shouldRespondToTableIndexPress() -> Bool{
        return activePage.value == .left
    }
}
