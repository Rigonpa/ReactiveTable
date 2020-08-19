//
//  SimpleCell.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 19/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

class SimpleCell: UITableViewCell {
    
    var viewModel: SimpleCellViewModel? {
        didSet {
            contentView.backgroundColor = .cyan
        }
    }
}
