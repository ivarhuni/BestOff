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

class BOViewModel: ViewModelErrorProtocol{
    
    //MARK: CategoryItem Protocol

    

    
    //MARK: ViewModelErrorProtocol
    var shouldShowError = Observable<Bool>(false)
    func showDataError(){
        shouldShowError.value = true
    }
    
    func hideDataError() {
        shouldShowError.value = false
    }
}
