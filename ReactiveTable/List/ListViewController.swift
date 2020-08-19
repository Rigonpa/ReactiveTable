//
//  ListViewController.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 19/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import SnapKit

class ListViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(SectionView.self, forHeaderFooterViewReuseIdentifier: "SectionView")
        table.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        table.register(SimpleCell.self, forCellReuseIdentifier: "SimpleCell")
        table.delegate = self
        table.dataSource = self
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
        label.text = "Press plus button to add new section to list"
        label.textAlignment = .center
        return label
    }()
    
    let disposable: CompositeDisposable
    
    let viewModel: ListViewModel
    init(viewModel: ListViewModel, disposable: CompositeDisposable) {
        self.viewModel = viewModel
        self.disposable = disposable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
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
            make.width.equalTo(view.snp.width)
            make.height.equalTo(80)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
        disposable += addButton.reactive.controlEvents(.touchUpInside).observe { [weak self] (_) in
            guard let self = self else { return }
            self.viewModel.addSectionButtonTapped()
        }
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionView") as? SectionView,
            let sectionViewModel = viewModel.sectionViewModel(at: section) else { fatalError()}
        sectionView.viewModel = sectionViewModel
        return sectionView
    }
}

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as? EmptyCell {
            guard let cellViewModel = viewModel.viewModel(at: indexPath) as? EmptyCellViewModel else { fatalError()}
            cell.viewModel = cellViewModel
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath) as? SimpleCell {
            guard let cellViewModel = viewModel.viewModel(at: indexPath) as? SimpleCellViewModel else { fatalError()}
            cell.viewModel = cellViewModel
            return cell
        } else {
            fatalError()
        }
    }
}
