//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol BrowserDataSourcing: UICollectionViewDataSource {
    func register(for collectionView: UICollectionView)
    func set(photos: [Photo])
}

final class BrowserViewDataSource: NSObject {
    private var photos = [Photo]()
}

// MARK: - UICollectionViewDataSource
extension BrowserViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TBI", for: indexPath)
        
        let label = UILabel()
        label.text = photos[indexPath.item].id
        
        cell.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
        
        return cell
    }
}

// MARK: - BrowserDataSourcing
extension BrowserViewDataSource: BrowserDataSourcing {
    func register(for collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TBI")
    }

    func set(photos: [Photo]) {
        self.photos = photos
    }
}