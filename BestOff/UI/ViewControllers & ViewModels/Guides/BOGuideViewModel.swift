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
    var numberOfSections = 0
    let swipeIndexIndicator = Observable<Int>(0)
    let tableDataSourceAnimationDuration:Double = 0.4
    
    //MARK: Other Properties
    let type = Endpoint.guides
    let disposeBag = DisposeBag()
    
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

        _ = self.category.observeNext{ model in
            
            guard let dataModel = model else{
                return
            }
            guard let dataSource = self.listDataSource.value else{
                return
            }
            dataSource.setDataModel(model: dataModel)
            
        }.dispose(in: disposeBag)
    }
}

//MARK: Networking
extension BOGuideViewModel{
    func getGuides(){
        getCategoryFromJSON(type: self.type)
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
