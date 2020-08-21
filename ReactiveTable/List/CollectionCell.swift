//
//  CollectionCell.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 20/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import DifferenceKit

class CollectionCell: UITableViewCell {
    
    lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        cv.dataSource = self
        cv.register(Item.self, forCellWithReuseIdentifier: "Item")
        return cv
    }()
    
    lazy var addItemButtom: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        return btn
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Please add new item"
        return label
    }()
    
    let serialDisposable = SerialDisposable()
    
    var viewModel: CollectionCellViewModel? {
        didSet {
            let compositeDisposable = CompositeDisposable()
            serialDisposable.inner = compositeDisposable
            
            collectionView.reloadData()
            
            updateUI()
            setupBindings(compositeDisposable: compositeDisposable)
        }
    }
    
    private func setupBindings(compositeDisposable: CompositeDisposable) {
        guard let viewModel = viewModel else { return }
        
        compositeDisposable += emptyLabel.reactive.isHidden <~ viewModel.notEmptyCollection
        
        compositeDisposable += viewModel.changeset.producer.startWithValues { [weak self] edit in
            self?.collectionView.reload(using: edit, setData: {[weak self] (data) in
                self?.viewModel?.setSourceData(itemViewModels: data)
            })
        }
        
        compositeDisposable += addItemButtom.reactive.controlEvents(.touchUpInside).observe { [weak self] (_) in
            self?.viewModel?.addNewItemButtonTapped()
        }
    }
    
    private func updateUI() {
        contentView.backgroundColor = .purple
        heightAnchor.constraint(equalToConstant: 87).isActive = true
        addSubview(collectionView)
        collectionView.backgroundColor = .systemPink
        collectionView.snp.remakeConstraints { make in
            make.leading.equalTo(snp.leading)
            make.top.equalTo(snp.top)
            make.trailing.equalTo(snp.trailing)
            make.height.equalTo(50)
        }
        
        addSubview(emptyLabel)
        emptyLabel.snp.remakeConstraints { make in
            make.leading.equalTo(snp.leading).offset(32)
            make.top.equalTo(snp.top).offset(16)
        }
        
        addSubview(addItemButtom)
        addItemButtom.snp.remakeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.top.equalTo(collectionView.snp.bottom).offset(8)
        }
    }
    
    deinit {
        serialDisposable.dispose()
    }
}

extension CollectionCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let viewModel = viewModel else { fatalError() }
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { fatalError() }
        return viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let item = collectionView.dequeueReusableCell(withReuseIdentifier: "Item", for: indexPath) as? Item,
            let itemViewModel = viewModel?.viewModel(at: indexPath) {
            item.viewModel = itemViewModel
            return item
        }
        fatalError()
    }
}
