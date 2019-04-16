//
//  AppCoordinator.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import UIKit

class BOAppCoordinator: BOCoordinator{
    
    private let window: UIWindow
    var childCoordinators: [BOCoordinator] = []
    let navController = UINavigationController()
    
    //MARK: Initialization
    public init(window: UIWindow) {
        
        self.window = window
        self.window.backgroundColor = .yellow
        self.window.rootViewController = navController
        self.start()
    }
    
    //MARK: - Public funtions
    public func start() {
        
        let mainCoordinator = BOMainCoordinator(navigationController: navController)
        mainCoordinator.start()
        self.window.makeKeyAndVisible()
    }
}
