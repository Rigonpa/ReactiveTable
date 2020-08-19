//
//  EmptyCell.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 19/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

class EmptyCell: UITableViewCell {
    
    var viewModel: EmptyCellViewModel? {
        didSet {
            contentView.backgroundColor = .orange
        }
    }
}
