//
// Created by Maxim Berezhnoy on 29/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol FeedCellCreating {
    func createFeedCellConfigurator(feedRouter: FeedRouting) -> FeedCellConfigurator
}

final class FeedCellFactory: FeedCellCreating {
    func createFeedCellConfigurator(feedRouter: FeedRouting) -> FeedCellConfigurator { 
        FeedCellConfigurator(router: feedRouter)
    }
}