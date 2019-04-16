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
    
    //MARK: Initialization
    public init(window: UIWindow) {
        
        self.window = window
        self.window.backgroundColor = .white
        self.start()
    }
    
    //MARK: - Public funtions
    
    public func start() {
        
        let mainCoord = BOMainCoordinator(tabController: self.tabBarController!)
        mainCoord.start()
        self.addChildCoordinator(childCoordinator: mainCoord)
        //self.window.rootViewController = self.tabBarController
        self.window.makeKeyAndVisible()
    }
}
