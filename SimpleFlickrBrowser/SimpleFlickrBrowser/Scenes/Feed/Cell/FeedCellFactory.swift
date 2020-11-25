//
// Created by Maxim Berezhnoy on 25/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol FeedCellCreating {
    func createConfigurator() -> FeedCellConfiguring
}

final class FeedCellFactory: FeedCellCreating {
    private let photoDataProvider: PhotoDataProviding

    init(photoDataProvider: PhotoDataProviding) {
        self.photoDataProvider = photoDataProvider
    }

    func createConfigurator() -> FeedCellConfiguring {
        FeedCellConfigurator(photoDataProvider: photoDataProvider)
    }
}
