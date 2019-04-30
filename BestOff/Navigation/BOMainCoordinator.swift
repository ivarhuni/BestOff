//
//  MainCoordinator.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import UIKit

class BOMainCoordinator: BOCoordinator{
    
    var childCoordinators: [BOCoordinator] = []
    let navController: UINavigationController
    
    //MARK: Initialize VCs & ViewModels
    public init(navigationController: UINavigationController){
        navController = navigationController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:
    public func start() {
        
        let guideVM = BOGuideViewModel(withIndexIndicator: 0)
       guideVM.getGuides()
        let guideVC = BOGuideViewController(viewModel: guideVM)
        navController.viewControllers = [guideVC]
    }
}

