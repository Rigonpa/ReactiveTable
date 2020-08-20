//
//  SimpleCell.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 19/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit
import ReactiveSwift

class SimpleCell: UITableViewCell {
    
    lazy var idLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var viewModel: SimpleCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            idLabel.text = viewModel.id
            updateUI()
        }
    }
    
    private func updateUI() {
        contentView.backgroundColor = .cyan
        contentView.addSubview(idLabel)
        idLabel.snp.remakeConstraints { make in
            make.leading.equalTo(snp.leading).offset(32)
            make.centerY.equalTo(snp.centerY)
        }
    }
}
