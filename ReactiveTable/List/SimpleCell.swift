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
    
    let serialDisposable = SerialDisposable()
    
    var viewModel: SimpleCellViewModel? {
        didSet {
            let compositeDisposable = CompositeDisposable()
            serialDisposable.inner = compositeDisposable
            
            setupBindings(compositeDisposable: compositeDisposable)
            updateUI()
        }
    }
    
    private func setupBindings(compositeDisposable: CompositeDisposable) {
        guard let viewModel = viewModel else { return }
        compositeDisposable += idLabel.reactive.text <~ viewModel.idLabelText
    }
    
    private func updateUI() {
        contentView.backgroundColor = .cyan
        contentView.addSubview(idLabel)
        idLabel.snp.remakeConstraints { make in
            make.leading.equalTo(snp.leading).offset(32)
            make.centerY.equalTo(snp.centerY)
        }
    }
    
    deinit {
        serialDisposable.dispose()
    }
}
