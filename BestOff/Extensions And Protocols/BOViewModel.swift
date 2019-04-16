//
//  BOViewModel.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

class BOViewModel: ViewModelErrorProtocol, CategoryItemProtocol{
    
    //MARK: CategoryItem Protocol
    var arrCategory = Observable<[BOCategoryModel]>([])
    
    func getCategory() -> BOCategoryModel? {
        guard let category = arrCategory.value[safe: 0] else{
            return nil
        }
        return category
    }
    
    func getCategoryItems() -> [BOCatItem] {
        guard let category = getCategory() else{
            return []
        }
        return category.items
    }
    
    //MARK: ViewModelErrorProtocol
    var shouldShowError = Observable<Bool>(false)
    func showDataError(){
        shouldShowError.value = true
    }
    
    func hideDataError() {
        shouldShowError.value = false
    }
}

    //MARK: VMNetworkProtocol
extension BOViewModel: ViewModelNetworkProtocol{
    
    func getCategoryFromJSON(type: Endpoint) {
        let categoryNetworkService = BOCategoryService()
        categoryNetworkService.getCategory(type) { [weak self] (model, error) in
            
            //Error handling
            guard let this = self else{
                return
            }
            if let nError = error{
                print(nError)
                this.showDataError()
                return
            }
            
            //No errors detected
            //Populate the data array with the model from the network callback
            //The VC has data bindings to the dataArray and will display data on it's screen on the array's value change
            guard let categoryModel = model else {
                this.arrCategory.value = []
                return
            }
            this.arrCategory.value = [categoryModel]
        }
    }
}
