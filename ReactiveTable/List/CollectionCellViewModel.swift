//
//  CollectionCellViewModel.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 20/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import Foundation
import ReactiveSwift
import DifferenceKit

class CollectionCellViewModel: CellViewModel {
    
    // MARK: - Stored variables
    let itemViewModels = MutableProperty<[ItemViewModel]>([])
    
    let changeset = MutableProperty(StagedChangeset<[ItemViewModel]>())
    
//    let serialDisposable = SerialDisposable() - Not necessary. Why?
    
    let notEmptyCollection = MutableProperty<Bool>(false)
    
    // MARK: - Init
    override init() {
        super.init()
        setupBindings()
    }
    
    // MARK: - Methods
    func addNewItemButtonTapped() {
        let itemViewModel = ItemViewModel()
        itemViewModel.delegate = self
        var mutableItemViewModels = itemViewModels.value
        mutableItemViewModels.append(itemViewModel)
        
        updateChangeset(itemViewModels: mutableItemViewModels)
    }
    
    private func setupBindings() {
        let collectionIsNotEmpty = itemViewModels.map { $0.isEmpty }.negate()
        notEmptyCollection <~ collectionIsNotEmpty // Why do not store this binding in a disposable as the other bindings through the app ¿?
    }
    
    private func updateChangeset(itemViewModels: [ItemViewModel]) {
        changeset.value = StagedChangeset<[ItemViewModel]>(source: self.itemViewModels.value, target: itemViewModels)
    }
    
    func setSourceData(itemViewModels: [ItemViewModel]) {
        self.itemViewModels.value = itemViewModels
    }
    
    // MARK: - Collection view methods
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        return itemViewModels.value.count
    }
    
    func viewModel(at indexPath: IndexPath) -> ItemViewModel? {
        guard indexPath.row < itemViewModels.value.count else { return nil }
        return itemViewModels.value[indexPath.row]
    }
}

extension CollectionCellViewModel: ItemViewModelDelegate {
    func removeItemButtonPressed(itemViewModel: ItemViewModel) {
        var mutableItemViewModels = itemViewModels.value
        mutableItemViewModels.removeAll(where: { $0 === itemViewModel })
        
        updateChangeset(itemViewModels: mutableItemViewModels)
    }
}
