//
//  EmptyCell.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 19/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

class EmptyCell: UITableViewCell {
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Add new cell by pressing plus button"
        return label
    }()
    
    var viewModel: EmptyCellViewModel? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        contentView.backgroundColor = .orange
        addSubview(emptyLabel)
        emptyLabel.snp.remakeConstraints { make in
            make.leading.equalTo(snp.leading).offset(32)
            make.centerY.equalTo(snp.centerY)
        }
    }
}
