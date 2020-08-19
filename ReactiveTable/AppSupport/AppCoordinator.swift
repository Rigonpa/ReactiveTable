//
//  AppCoordinator.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 19/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit
import ReactiveSwift

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let navigationController = UINavigationController()
        let compositeDisposable = CompositeDisposable()
        let listViewModel = ListViewModel(compositeDisposable: compositeDisposable)
        let listViewController = ListViewController(viewModel: listViewModel, compositeDisposable: compositeDisposable)
        navigationController.viewControllers = [listViewController]
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    override func finish() {
        
    }
}
