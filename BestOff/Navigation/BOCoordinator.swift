//
//  Coordinator.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

protocol BOCoordinator: class {
    
    var childCoordinators: [BOCoordinator] { get set }
    func start()
}

extension BOCoordinator {
    
    /// Add a child coordinator to the parent
    func addChildCoordinator(childCoordinator: BOCoordinator) {
        childCoordinators.append(childCoordinator)
    }
    
    /// Remove a child coordinator from the parent
    func removeChildCoordinator(childCoordinator: BOCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
    }
}
