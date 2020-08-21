//
//  Item.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 20/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit
import ReactiveSwift

class Item: UICollectionViewCell {
    
    lazy var itemLabel: UILabel = {
        let label = UILabel()
        label.text = "Item"
        label.textColor = .white
        return label
    }()
    
    lazy var trashButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        return btn
    }()
    
    let serialDisposable = SerialDisposable()
    
    var viewModel: ItemViewModel? {
        didSet {
            let compositeDisposable = CompositeDisposable()
            serialDisposable.inner = compositeDisposable
            
            setupBindings(compositeDisposable: compositeDisposable)
            updateUI()
        }
    }
    
    private func setupBindings(compositeDisposable: CompositeDisposable) {
        guard let viewModel = viewModel else { return }
        compositeDisposable += trashButton.reactive.controlEvents(.touchUpInside).observe {(_) in
            viewModel.removeItemButtonTapped()
        }
    }
    
    private func updateUI() {
        contentView.backgroundColor = .black
        addSubview(trashButton)
        trashButton.snp.remakeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalTo(snp.bottom)
        }
        
        addSubview(itemLabel)
        itemLabel.snp.remakeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.top.equalTo(snp.top)
        }
    }
    
    deinit {
        serialDisposable.dispose()
    }
}
