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

typealias SectionType = ArraySection<SectionViewModel, CellViewModel>

class ListViewModel {
    
    // MARK: - Stored variables
    
    let changeset = MutableProperty(StagedChangeset<[SectionType]>()) // Tercero
    
    let sections = MutableProperty<[SectionType]>([]) // Segundo
    
    let compositeDisposable: CompositeDisposable // Primero
    
    // MARK: - Init
    init(compositeDisposable: CompositeDisposable) {
        self.compositeDisposable = compositeDisposable
    }
    
    // MARK: - Methods
    func setDataSource(sections: [SectionType]) {
        self.sections.value = sections
    }
    
    func updateChangeset(sections: [SectionType]) {
        changeset.value = StagedChangeset<[SectionType]>(source: self.sections.value, target: sections)
    }
    
    func addSectionButtonTapped(){
        var mutableSections = sections.value
        mutableSections.append(SectionType(model: SectionViewModel(), elements: [EmptyCellViewModel()]))
        
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
