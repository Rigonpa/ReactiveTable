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
import DifferenceKit

class ListViewController: UIViewController {
    
    // MARK: - Stored variables
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(SectionView.self, forHeaderFooterViewReuseIdentifier: "SectionView")
        table.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        table.register(SimpleCell.self, forCellReuseIdentifier: "SimpleCell")
        table.register(CollectionCell.self, forCellReuseIdentifier: "CollectionCell")
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
    
    let compositeDisposable: CompositeDisposable
    
    let viewModel: ListViewModel
    
    // MARK: - Init
    init(viewModel: ListViewModel, compositeDisposable: CompositeDisposable) {
        self.viewModel = viewModel
        self.compositeDisposable = compositeDisposable
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle methods
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
    
    // MARK: - Private methods
    private func showNewCellAlert() {
        let alertController = UIAlertController(title: "New cell", message: "Please select desired option", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Simple cell", style: .default, handler: {[weak self] (_) in
            self?.viewModel.addNewSimpleCell()
        }))
        alertController.addAction(UIAlertAction(title: "Collection cell", style: .default, handler: {[weak self] (_) in
            self?.viewModel.addNewCollectionCell()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupBindings() {
        compositeDisposable += viewModel.changeset.producer.startWithValues {[weak self] edit in // Segundo
            self?.tableView.reload(using: edit, with: UITableView.RowAnimation.fade) {[weak self] (data) in
                self?.viewModel.setDataSource(sections: data)
            }
        }
        
        compositeDisposable += emptyLabel.reactive.isHidden <~ viewModel.sectionsNotEmpty // Tercero
            
        compositeDisposable += addButton.reactive.controlEvents(.touchUpInside).observe { [weak self] (_) in // Primero
            guard let self = self else { return }
            self.viewModel.addSectionButtonTapped()
        }
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionView") as? SectionView,
            let sectionViewModel = viewModel.sectionViewModel(at: section) else { return nil }
        sectionView.viewModel = sectionViewModel
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.viewModel(at: indexPath) is CollectionCellViewModel {
            return 80.0
        }
        return 54.0
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as? EmptyCell,
            let cellViewModel = viewModel.viewModel(at: indexPath) as? EmptyCellViewModel {
            cell.viewModel = cellViewModel
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath) as? SimpleCell,
            let cellViewModel = viewModel.viewModel(at: indexPath) as? SimpleCellViewModel {
            cell.viewModel = cellViewModel
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as? CollectionCell,
            let cellViewModel = viewModel.viewModel(at: indexPath) as? CollectionCellViewModel {
            cell.viewModel = cellViewModel
            return cell
        }
        fatalError()
    }
}

extension ListViewController: ListViewModelDelegate {
    func addNewCellToTable() {
        showNewCellAlert()
    }
}
