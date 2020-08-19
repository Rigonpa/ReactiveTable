//
//  SectionViewModel.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 19/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import Foundation
import DifferenceKit

class SectionViewModel {
    
    let id = UUID().uuidString
    
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
