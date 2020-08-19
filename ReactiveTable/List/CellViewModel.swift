//
//  CellViewModel.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 19/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import Foundation
import DifferenceKit

class CellViewModel {
    
    let id = UUID().uuidString
    
}

extension CellViewModel: Differentiable {
    var differenceIdentifier: String {
        return id
    }
    
    func isContentEqual(to source: CellViewModel) -> Bool {
        return id == source.id
    }
    
    typealias DifferenceIdentifier = String
}
