//
// Created by Maxim Berezhnoy on 23/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol FeedDataSourcing: UITableViewDataSource {
    var photoCount: Int { get }

    func register(for tableView: UITableView)
    func add(photos: [Photo])
    func set(photos: [Photo])
}

final class FeedViewDataSource: NSObject {
    private let feedCellConfigurator: FeedCellConfiguring
    private var photos = [Photo]()

    init(feedCellConfigurator: FeedCellConfiguring) {
        self.feedCellConfigurator = feedCellConfigurator
    }
}

// MARK: - UITableViewDataSource

extension FeedViewDataSource: UITableViewDataSource {
    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        1
    }

    public func numberOfSections(in _: UITableView) -> Int {
        photos.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueFeedCell(from: tableView, at: indexPath)

        let photo = photos[indexPath.section]

        feedCellConfigurator.configure(cell)
        cell.display(photo: photo)

        return cell
    }
}

// MARK: - FeedDataSourcing

extension FeedViewDataSource: FeedDataSourcing {
    var photoCount: Int {
        photos.count
    }

    func register(for tableView: UITableView) {
        tableView.dataSource = self
        tableView.register(FeedViewCell.self, forCellReuseIdentifier: FeedViewCell.identifier)
    }

    func add(photos: [Photo]) {
        self.photos.append(contentsOf: photos)
    }

    func set(photos: [Photo]) {
        self.photos = photos
    }
}

// MARK: - FeedViewCell dequeuing

extension FeedViewDataSource {
    func dequeueFeedCell(from tableView: UITableView, at indexPath: IndexPath) -> FeedViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedViewCell.identifier, for: indexPath)

        guard let feedCell = cell as? FeedViewCell else {
            fatalError("Unexpected cell type while dequeuing in \(FeedViewDataSource.self): got \(cell)")
        }

        return feedCell
    }
}
