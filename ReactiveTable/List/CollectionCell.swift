//
//  CollectionCell.swift
//  ReactiveTable
//
//  Created by Ricardo González Pacheco on 20/08/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

class CollectionCell: UITableViewCell {
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.register(Item.self, forCellWithReuseIdentifier: "Item")
        return cv
    }()
    
    lazy var addItemButtom: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        return btn
    }()
    
    var viewModel: CollectionCellViewModel? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        contentView.backgroundColor = .purple
        addSubview(collectionView)
        collectionView.backgroundColor = .systemPink
        collectionView.snp.remakeConstraints { make in
            make.leading.equalTo(snp.leading)
            make.top.equalTo(snp.top)
            make.trailing.equalTo(snp.trailing)
            make.width.equalTo(30)
        }
        
        addSubview(addItemButtom)
        addItemButtom.snp.remakeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.top.equalTo(collectionView.snp.bottom).offset(16)
        }
    }
    
}

extension CollectionCell: UICollectionViewDelegate {
    
}

extension CollectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }
    
    
}
