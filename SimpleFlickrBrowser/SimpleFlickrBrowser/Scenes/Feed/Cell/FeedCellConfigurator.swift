//
// Created by Maxim Berezhnoy on 27/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol FeedCellConfiguring {
    func configure(_ cell: FeedViewCell)
}

final class FeedCellConfigurator: FeedCellConfiguring {
    private let router: FeedRouting

    init(router: FeedRouting) { 
        self.router = router 
    }

    func configure(_ cell: FeedViewCell) {
        cell.router = router
    }
}
