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
    let sections = MutableProperty<[SectionType]>([]) // Segundo
    
    let disposable: Disposable // Primero
    init(disposable: Disposable) {
        self.disposable = disposable
    }
    
}
