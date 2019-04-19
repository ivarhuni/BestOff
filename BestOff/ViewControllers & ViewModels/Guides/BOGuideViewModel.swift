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
    
    //MARK: Protocol properties
    var dataSource = Observable<BOTableDataSourceProtocol?>(nil)
    var numberOfSections = 0
    
    //MARK: Other Properties
    let type = Endpoint.guides
    let disposeBag = DisposeBag()
    
    //MARK: Init
    override init(){
        super.init()
        self.dataSource.value = BOGuideTableDataSource()
        createBonding()
    }
    
    //MARK: UI Bindings
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
    
    //MARK: Networking
    func getGuides(){
        getCategoryFromJSON(type: self.type)
    }
}
