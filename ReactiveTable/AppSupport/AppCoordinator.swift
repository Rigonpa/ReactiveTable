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
        let disposable = CompositeDisposable()
        let listViewModel = ListViewModel(disposable: disposable)
        let listViewController = ListViewController(viewModel: listViewModel, disposable: disposable)
        navigationController.viewControllers = [listViewController]
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    override func finish() {
        
    }
}
