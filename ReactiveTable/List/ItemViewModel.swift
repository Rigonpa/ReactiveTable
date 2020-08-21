//
//  ItemViewModel.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 20/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import Foundation
import DifferenceKit

protocol ItemViewModelDelegate {
    func removeItemButtonPressed(itemViewModel: ItemViewModel)
}

class ItemViewModel {
    
    var delegate: ItemViewModelDelegate?
    
    let id = UUID().uuidString
    
    func removeItemButtonTapped() {
        self.delegate?.removeItemButtonPressed(itemViewModel: self)
    }
    
}

extension ItemViewModel: Differentiable {
    var differenceIdentifier: String {
        return id
    }
    
    func isContentEqual(to source: ItemViewModel) -> Bool {
        return id == source.id
    }
    
    typealias DifferenceIdentifier = String
}
