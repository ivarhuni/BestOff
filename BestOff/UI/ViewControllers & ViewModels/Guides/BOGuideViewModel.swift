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
        
        let bigCellIndex = 1
        
        if index == bigCellIndex{ changeDataSourceToDetail() }
    }
    
    func getListCellHeightAt(indexPath: IndexPath) -> CGFloat {
        
        if isDetailDataSourceActive(){
            return getDetailDataSourceHeightFor(indexPath: indexPath)
        }
        else{
            return getRegularListDataSourceHeightFor(indexPath: indexPath)
        }
    }

    
    private func changeDataSourceToDetail(){
        
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
    
    private func getDetailDataSourceHeightFor(indexPath: IndexPath) -> CGFloat{
        
        let bigImgTopCellIndex = 0
        
        if indexPath.row == bigImgTopCellIndex{
            return bigCellRowHeight
        }
        return 10
    }
    
    private func getRegularListDataSourceHeightFor(indexPath: IndexPath) -> CGFloat{
        
        let txtHeaderRowHeight:CGFloat = 71.0
        if indexPath.row == 0 { return txtHeaderRowHeight }
        
        
        if indexPath.row == 1 { return bigCellRowHeight }
        
        //DoubleItemCellHeight
        let leftSpacingToItemImg:CGFloat = 20.0
        let rightSpacingToItemImg:CGFloat = 10.0
        
        let itemImgWidthAndHeight = (UIScreen.main.bounds.width - 2 * ( leftSpacingToItemImg - rightSpacingToItemImg))/2.0
        
        let lblTitleSpacingToImg:CGFloat = 10
        let lblTitleSpacginToBottom:CGFloat = 10
        
        let lblHeight:CGFloat = 42.0
        
        let itemRowHeight:CGFloat = itemImgWidthAndHeight + lblTitleSpacingToImg + lblTitleSpacginToBottom + lblHeight
        
        return itemRowHeight
    }
}

extension BOGuideViewModel{
    
    func changeDataSourceTo(dataSource: BOCategoryListDataSourceProtocol){
        
        
    }
}
