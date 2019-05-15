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
    var dataSource = Observable<BOCategoryListDataSourceProtocol?>(nil)
    var numberOfSections = 0
    let swipeIndexIndicator = Observable<Int>(0)
    
    //MARK: Other Properties
    let type = Endpoint.guides
    let disposeBag = DisposeBag()
    
    //MARK: Magic number animation/duration constants
    let menuAnimationDuration: Double = 0.5
    let alphaVisible: CGFloat = 1.0
    let alphaInvisible: CGFloat = 0
    
    //MARK: Menu
    let menuOpen = Observable<Bool>(false)
    
    //MARK: Init
    required init(index: Int? = 0){
        
        super.init()
        self.dataSource.value = BOGuideTableDataSource()
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
            guard let dataSource = self.dataSource.value else{
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
        
        if index == 1{
            
            
        }
    }
    
    static func getCellHeightAt(indexPath: IndexPath) -> CGFloat {
        
        let txtHeaderRowHeight:CGFloat = 71.0
        if indexPath.row == 0 { return txtHeaderRowHeight }
        
        let bigCellRowHeight:CGFloat = 310
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
