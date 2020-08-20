//
//  SectionView.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 19/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

class SectionView: UITableViewHeaderFooterView {
    
    lazy var titleSection: UILabel = {
        let label = UILabel()
        label.text = "Section 1"
        return label
    }()
    
    lazy var addCellButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        return btn
    }()
    
    lazy var removeSectionButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        return btn
    }()
    
    let compositeDisposable = CompositeDisposable()
    
    var viewModel: SectionViewModel? {
        didSet {
            setupBindings()
            updateUI()
        }
    }
    
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        updateUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    private func setupBindings() {
        guard let viewModel = viewModel else { return }
        compositeDisposable += titleSection.reactive.text <~ viewModel.sectionTitle
        
        compositeDisposable += addCellButton.reactive.controlEvents(.touchUpInside).observe {[weak self] (_) in
            self?.viewModel?.addNewCellButtonTapped()
        }
    }
    
    private func updateUI() {
        contentView.backgroundColor = .green
        addSubview(titleSection)
        titleSection.snp.remakeConstraints { make in
            make.leading.equalTo(snp.leading).offset(16)
            make.centerY.equalTo(snp.centerY)
            make.width.equalTo(200)
        }
        
        addSubview(addCellButton)
        addCellButton.snp.remakeConstraints { make in
            make.trailing.equalTo(snp.trailing).offset(-64)
            make.centerY.equalTo(snp.centerY)
        }
        
        addSubview(removeSectionButton)
        removeSectionButton.snp.remakeConstraints { make in
            make.trailing.equalTo(snp.trailing).offset(-24)
            make.centerY.equalTo(snp.centerY)
        }
    }
    
    deinit {
        compositeDisposable.dispose()
    }
}
