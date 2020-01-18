//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol BrowserDataSourcing: UICollectionViewDataSource {
    var photoCount: Int { get }

    func register(for collectionView: UICollectionView)
    func add(photos: [Photo])
    func set(photos: [Photo])
}

final class BrowserViewDataSource: NSObject {
    private let cellConfigurator: BrowserCellConfiguring

    private var photos = [Photo]()

    init(cellConfigurator: BrowserCellConfiguring) {
        self.cellConfigurator = cellConfigurator

        super.init()
    }
}

// MARK: - UICollectionViewDataSource

extension BrowserViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueBrowserCell(from: collectionView, at: indexPath)

        let photo = photos[indexPath.item]

        cellConfigurator.configure(cell: cell, with: photo)

        return cell
    }
}

// MARK: - BrowserDataSourcing

extension BrowserViewDataSource: BrowserDataSourcing {
    var photoCount: Int {
        photos.count
    }

    func register(for collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.register(BrowserViewCell.self, forCellWithReuseIdentifier: BrowserViewCell.identifier)
    }

    func add(photos: [Photo]) {
        self.photos.append(contentsOf: photos)
    }

    func set(photos: [Photo]) {
        self.photos = photos
    }
}

// MARK: - BrowserViewCell dequeuing

extension BrowserViewDataSource {
    func dequeueBrowserCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> BrowserViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrowserViewCell.identifier, for: indexPath)

        guard let browserCell = cell as? BrowserViewCell else {
            fatalError("Unexpected cell type while dequeuing in \(BrowserViewDataSource.self): got \(cell)")
        }

        return browserCell
    }
}
