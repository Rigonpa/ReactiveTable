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
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SectionView.self, forHeaderFooterViewReuseIdentifier: "SectionView")
        table.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        table.register(SimpleCell.self, forCellReuseIdentifier: "SimpleCell")
        table.register(CollectionCell.self, forCellReuseIdentifier: "CollectionCell")
        table.delegate = self
        table.dataSource = self
        
        table.dropDelegate = self
        table.dragDelegate = self
        table.dragInteractionEnabled = true
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

extension ListViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let sourceIndexPath = coordinator.items.first?.sourceIndexPath,
            let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        viewModel.performDrop(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        guard let destinationIndexPath = destinationIndexPath,
            let sourceIndexPath = session.localDragSession?.localContext as? IndexPath else {
                return UITableViewDropProposal(operation: .forbidden)
        }
        // Use insert INTO when the destinationIndexPath is an empty cell -> This will cause performDrop to trigger
        if viewModel.hasEmptyCell(at: destinationIndexPath) {
            return UITableViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
        }
        
        // Use insert AT when the dragging from a section and dropping on another, OR
        // when drag and droppping within the same section but there are more 1 element
        if(sourceIndexPath.section == destinationIndexPath.section
            && viewModel.numberOfRows(at: destinationIndexPath.section) > 1)
            || sourceIndexPath.section != destinationIndexPath.section {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        return UITableViewDropProposal(operation: .forbidden)
    }
}

extension ListViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = indexPath
        return []
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return viewModel.canMoveRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionView") as? SectionView,
            let sectionViewModel = viewModel.sectionViewModel(at: section) else { return nil }
        sectionView.viewModel = sectionViewModel
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54.0
    }
}

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard viewModel.canRemoveRow(at: indexPath)  else { return nil }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: {[weak self] _,_,_ in
            self?.viewModel.removeCell(at: indexPath)
        })
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
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
