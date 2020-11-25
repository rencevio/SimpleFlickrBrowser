//
// Created by Maxim Berezhnoy on 24/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol FeedCellConfiguring {
    func configure(cell: ConfigurableFeedCell, with photo: Photo)
}

final class FeedCellConfigurator: FeedCellConfiguring {
    private let photoDataProvider: PhotoDataProviding

    init(photoDataProvider: PhotoDataProviding) {
        self.photoDataProvider = photoDataProvider
    }

    func configure(cell: ConfigurableFeedCell, with photo: Photo) {
        let presenter = FeedCellPresenter()
        let interactor = FeedCellInteractor(presenter: presenter, photoDataProvider: photoDataProvider)

        presenter.view = cell

        cell.configure(interactor: interactor, photo: photo)
    }
}
