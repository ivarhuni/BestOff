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

class BOGuideViewModel: BOViewModel, ViewModelDataSourceProtocol {
    
    //MARK: Protocol properties
    var listDataSource = Observable<BOCategoryListDataSourceProtocol?>(nil)
    var detailListDataSource = Observable<BOCategoryDetailListProtocol?>(nil)
    var
    var numberOfSections = 0
    let swipeIndexIndicator = Observable<Int>(0)
    let tableDataSourceAnimationDuration:Double = 0.4

    let disposeBag = DisposeBag()
    
    var guides = Observable<BOCategoryModel?>(nil)
    var rvkDrink = Observable<BOCategoryModel?>(nil)
    var rvkActivities = Observable<BOCategoryModel?>(nil)
    var rvkShopping = Observable<BOCategoryModel?>(nil)
    var rvkDining = Observable<BOCategoryModel?>(nil)
    
    //MARK: Magic number animation/duration constants
    let menuAnimationDuration: Double = 0.5
    let alphaVisible: CGFloat = 1.0
    let alphaInvisible: CGFloat = 0
    
    //RowHeights used in both types of tables
    let bigCellRowHeight:CGFloat = 310
    
    //MARK: Menu
    let menuOpen = Observable<Bool>(false)
    
    //MARK: Init
    required init(index: Int? = 0){
        
        super.init()
        self.listDataSource.value = BOGuideTableDataSource()
        createBonding()
        guard let idx = index else{
            return
        }
        swipeIndexIndicator.value = idx
    }
}

//MARK: Databindings
extension BOGuideViewModel{
    
    private func createBonding(){

        _ = self.guides.observeNext{ model in
            
            guard let dataModel = model else{ return }
            guard let guideListdataSource = self.listDataSource.value else { return }
            
            guideListdataSource.setDataModel(model: dataModel)
        }.dispose(in: disposeBag)
        
        _ = self.rvkShopping.observeNext{ model in
        
            guard let dataModel = model else { return }
            
        }
        
    }
}



extension BOGuideViewModel: vmTableViewDelegate{
    
    func tableViewPressedAt(_ index: Int) {
        
        let bigGuideCellIndex = 1
        if index == bigGuideCellIndex { changeDataSourceToFirstDetail() }
    }
    
    func changeDataSourceToDetailWith(item: BOCatItem){
        
        detailListDataSource.value = BOGuideDetailTableDataSource(catItem: item)
    }
    
    private func changeDataSourceToFirstDetail(){
        
        guard let topCellItem = listDataSource.value?.categoryModel.value?.items[safe: 0] else {
            
            print("unable to get topcell item")
            return
        }
        
        detailListDataSource.value = BOGuideDetailTableDataSource(catItem: topCellItem)
    }
    
    private func isDetailDataSourceActive() -> Bool{
        if detailListDataSource.value == nil { return false }
        return true
    }
}

extension BOGuideViewModel{
    
    func changeDataSourceToDefault(){
        
        detailListDataSource.value = nil
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
