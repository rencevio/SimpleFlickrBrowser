//
// Created by Maxim Berezhnoy on 23/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol FeedDataSourcing: UITableViewDataSource {
//    var photoCount: Int { get }

//    func register(for collectionView: UICollectionView)
//    func add(photos: [Photo])
//    func set(photos: [Photo])
}

final class FeedViewDataSource: NSObject {
//    private let cellConfigurator: BrowserCellConfiguring

    private var photos = [Photo]()

    override init(
//            cellConfigurator: BrowserCellConfiguring
    ) {
//        self.cellConfigurator = cellConfigurator

        super.init()
    }
}

// MARK: - UITableViewDataSource

extension FeedViewDataSource: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { fatalError("tableView(_:numberOfRowsInSection:) has not been implemented") }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { fatalError("tableView(_:cellForRowAt:) has not been implemented") }
}

// MARK: - FeedDataSourcing

extension FeedViewDataSource: FeedDataSourcing {

}

