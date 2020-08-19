//
//  Coordinator.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 19/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import Foundation

class Coordinator {
    fileprivate var childCoordinators: [Coordinator] = []
    
    func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
    func finish(){
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
    func addChildCoordinator(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(coordinator: Coordinator) {
        childCoordinators.removeAll(where: { $0 == coordinator })
    }
    
    func removeAllChildCoordinatorWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T == false }
    }
    
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
}

extension Coordinator: Equatable {
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        lhs.childCoordinators == rhs.childCoordinators
    }
}
