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

class BOGuideViewModel{
    
    let arrGuideCategory = Observable<[BOCategoryModel]>([])
    let shouldShowError = Observable<Bool>(false)
    
    init(){
        
        
    }
    
    //MARK: Networking
    public func getGuides(){
        
        let guideNetworkService = BOCategoryService()
        
        guideNetworkService.getCategory(.guides) { [weak self] (model, error) in
            
            //Error handling
            guard let this = self else{
                return
            }
            if let nError = error{
                print(nError)
                this.showError()
                return
            }
            
            //No errors detected
            //Populate the data array with the model from the network callback
            //The VC has data bindings to the dataArray and will display data on it's screen on the array's value change
            guard let guideCategory = model else {
                this.arrGuideCategory.value = []
                return
            }
            this.arrGuideCategory.value = [guideCategory]
        }
    }
}

//MARK: Errors
extension BOGuideViewModel{
    
    //MARK: Error Handling
    private func showError(){
        shouldShowError.value = true
    }
    
    private func hideError(){
        shouldShowError.value = false
    }
}
