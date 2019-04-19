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

class BOGuideViewModel: BOViewModel, ViewModelDataSourceProtocol{
    
    var dataSource = Observable<BOTableDataSourceProtocol?>(nil)
    var numberOfSections = 0
    
    let disposeBag = DisposeBag()
    
    let hasRegisteredCell = false
    
    override init(){
        super.init()
        self.dataSource.value = BOGuideTableDataSource()
        createBonding()
    }
    
    func createBonding(){

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
    
    func getGuides(){
        getCategoryFromJSON(type: .guides)
    }
}
