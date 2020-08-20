//
//  SectionViewModel.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 19/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import Foundation
import DifferenceKit
import ReactiveSwift

protocol SectionViewModelDelegate {
    func addNewCellButtonTapped(id: String)
}

class SectionViewModel {
    
    var delegate: SectionViewModelDelegate?
    
    var sectionTitle = MutableProperty<String?>(nil)
    
    let id = UUID().uuidString
    
    func addNewCellButtonTapped() {
        self.delegate?.addNewCellButtonTapped(id: id)
    }
    
}

extension SectionViewModel: Differentiable {
    var differenceIdentifier: String {
        return id
    }
    
    func isContentEqual(to source: SectionViewModel) -> Bool {
        return id == source.id
    }
    
    typealias DifferenceIdentifier = String
}

extension SectionViewModel: Equatable {
    static func == (lhs: SectionViewModel, rhs: SectionViewModel) -> Bool {
        return lhs === rhs
    }
}
