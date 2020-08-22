//
//  ListViewModel.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 19/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import Foundation
import ReactiveSwift
import DifferenceKit

protocol ListViewModelDelegate {
    func addNewCellToTable()
}

typealias SectionType = ArraySection<SectionViewModel, CellViewModel>

class ListViewModel {
    
    // MARK: - Stored variables
    var selectedSectionViewModel: SectionViewModel? // Sexto
    
    var delegate: ListViewModelDelegate? // Quinto
    
    let sectionsNotEmpty = MutableProperty<Bool>(false) // Cuarto
    
    let changeset = MutableProperty(StagedChangeset<[SectionType]>()) // Tercero
    
    let sections = MutableProperty<[SectionType]>([]) // Segundo
    
    let compositeDisposable: CompositeDisposable // Primero
    
    // MARK: - Init
    init(compositeDisposable: CompositeDisposable) {
        self.compositeDisposable = compositeDisposable
        setupBindings()
    }
    
    // MARK: - Methods
    func removeCell(at indexPath: IndexPath) {
        var mutableSectionsCopy = sections.value
        mutableSectionsCopy[indexPath.section].elements.remove(at: indexPath.row)
        
        updateChangeset(sections: mutableSectionsCopy)
    }
    
    func canRemoveRow(at indexPath: IndexPath) -> Bool {
        return !(sections.value[indexPath.section].elements[indexPath.row] is EmptyCellViewModel)
    }
    
    func addNewCollectionCell() {
        guard let sectionIndex = sections.value.firstIndex(where: { $0.model === selectedSectionViewModel}) else { return}
        
        var mutableSectionsCopy = sections.value
        
        mutableSectionsCopy[sectionIndex].elements.removeAll(where: { $0 is EmptyCellViewModel})
        
        let collectionCellViewModel = CollectionCellViewModel()
        mutableSectionsCopy[sectionIndex].elements.append(collectionCellViewModel)
        
        updateChangeset(sections: mutableSectionsCopy)
    }
    
    func addNewSimpleCell() {
        guard let sectionIndex = sections.value.firstIndex (where: { (eachSectionAlreadyInSections) -> Bool in
            eachSectionAlreadyInSections.model === selectedSectionViewModel
        }) else { return }
        
        var mutableSectionsCopy = sections.value
        
        let simpleCellViewModel = SimpleCellViewModel()
        
        mutableSectionsCopy[sectionIndex].elements.removeAll(where: { $0 is EmptyCellViewModel })
        
        mutableSectionsCopy[sectionIndex].elements.append(simpleCellViewModel)
        
        updateChangeset(sections: mutableSectionsCopy)
        
    }
    
    func setupBindings() {
        let sectionsArrayIsNotEmpty = sections.map { !$0.isEmpty }
        sectionsNotEmpty <~ sectionsArrayIsNotEmpty
    }
    
    func setDataSource(sections: [SectionType]) {
        self.sections.value = sections
    }
    
    func updateChangeset(sections: [SectionType]) {
        changeset.value = StagedChangeset<[SectionType]>(source: self.sections.value, target: sections)
    }
    
    func addSectionButtonTapped(){
        var mutableSections = sections.value
        let sectionViewModel = SectionViewModel()
        sectionViewModel.delegate = self
        sectionViewModel.sectionTitle.value = "Section \(sections.value.count + 1)"
        mutableSections.append(SectionType(model: sectionViewModel, elements: [EmptyCellViewModel()]))
        
        updateChangeset(sections: mutableSections)
    }
    
    // MARK: - TableView methods
    func sectionViewModel(at section: Int) -> SectionViewModel? {
        guard section < sections.value.count else { return nil }
        return sections.value[section].model
    }
    
    func numberOfSections() -> Int {
        return sections.value.count
    }
    
    func numberOfRows(at section: Int) -> Int {
        return sections.value[section].elements.count
    }
    
    func viewModel(at indexPath: IndexPath) -> CellViewModel {
        return sections.value[indexPath.section].elements[indexPath.row]
    }
}

extension ListViewModel: SectionViewModelDelegate {
    func removeSectionButtonTapped(sectionViewModel: SectionViewModel) {
        var mutableSectionsCopy = sections.value
        mutableSectionsCopy.removeAll(where: { $0.model === sectionViewModel })
        
        updateChangeset(sections: mutableSectionsCopy)
    }
    
    func addNewCellButtonTapped(sectionViewModel: SectionViewModel) {
        selectedSectionViewModel = sectionViewModel
        self.delegate?.addNewCellToTable()
    }
}
