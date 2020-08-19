//
//  ListViewController.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 19/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit
import ReactiveSwift

class ListViewController: UIViewController {
    
    let disposable: Disposable
    
    let viewModel: ListViewModel
    init(viewModel: ListViewModel, disposable: Disposable) {
        self.viewModel = viewModel
        self.disposable = disposable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
