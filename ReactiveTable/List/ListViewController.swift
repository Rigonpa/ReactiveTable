//
//  ListViewController.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 19/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit
import ReactiveSwift
import SnapKit

class ListViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(SectionView.self, forHeaderFooterViewReuseIdentifier: "SectionView")
        table.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        table.register(SimpleCell.self, forCellReuseIdentifier: "SimpleCell")
//        table.delegate = self
//        table.dataSource = self
//        table.dragDelegate = self
//        table.dropDelegate = self
        table.tableFooterView = UIView()
        return table
    }()
    
    lazy var addButton: UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "plus")
        image?.withRenderingMode(.alwaysTemplate)
        btn.setImage(image, for: .normal)
        btn.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 55), forImageIn: .normal)
        return btn
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap add button to enter new section"
        return label
    }()
    
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
        view.backgroundColor = .white
        tableView.backgroundColor = .blue
        
        view.addSubview(tableView)
        tableView.snp.remakeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.top.equalTo(view.snp.top)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        view.addSubview(addButton)
        addButton.snp.remakeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(-32)
            make.bottom.equalTo(view.snp.bottom).offset(-32)
            make.size.equalTo(64)
        }
        
        view.addSubview(emptyLabel)
        emptyLabel.snp.remakeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.size.equalTo(300)
        }
    }
}
