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

class BOGuideViewModel: BOViewModel, ViewModelDataSourceProtocol, initWithIndexIndicator{
    
    //MARK: Protocol properties
    var dataSource = Observable<BOTableDataSourceProtocol?>(nil)
    var numberOfSections = 0
    let swipeIndexIndicator = Observable<Int>(0)
    
    //MARK: Other Properties
    let type = Endpoint.guides
    let disposeBag = DisposeBag()
    
    //MARK: Init
    required init(withIndexIndicator index: Int){
        super.init()
        self.dataSource.value = BOGuideTableDataSource()
        createBonding()
        swipeIndexIndicator.value = index
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
    
    func getCellHeight() -> CGFloat {
        return 100
    }
}
