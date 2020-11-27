//
// Created by Maxim Berezhnoy on 23/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

final class FeedFactory {
    func createViewController(photoCollectionFetcher: PhotoCollectionFetching) -> FeedViewController {
        let presenter = FeedPresenter()
        let interactor = FeedInteractor(presenter: presenter, photoCollectionFetcher: photoCollectionFetcher)

        let dataSource = createDataSource()

        let viewController = FeedViewController(interactor: interactor, dataSource: dataSource)

        presenter.view = viewController

        return viewController
    }

    private func createDataSource() -> FeedDataSourcing {
        FeedViewDataSource()
    }
}
