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
    var dataSource = Observable<BOTableDataSourceProtocol?>(nil)
    var numberOfSections = 0
    let swipeIndexIndicator = Observable<Int>(0)
    
    //MARK: Other Properties
    let type = Endpoint.guides
    let disposeBag = DisposeBag()
    
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
        print("table pressed at index")
    }
    
    static func getCellHeightAt(indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            return 295
            
        }
        return 268
    }
}

//MARK: Header
extension BOGuideViewModel{
    
    func setHeaderHeight(){
        
    }
}
