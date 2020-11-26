//
// Created by Maxim Berezhnoy on 23/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

final class FeedFactory {
    func createViewController(photoDataProvider: PhotoDataProviding,
                              photoCollectionFetcher: PhotoCollectionFetching) -> FeedViewController {
        let presenter = FeedPresenter()
        let interactor = FeedInteractor(presenter: presenter, photoCollectionFetcher: photoCollectionFetcher)

        let dataSource = createDataSource(photoDataProvider: photoDataProvider)

        let viewController = FeedViewController(interactor: interactor, dataSource: dataSource)

        presenter.view = viewController

        return viewController
    }

    private func createDataSource(photoDataProvider: PhotoDataProviding) -> FeedDataSourcing {
        let cellFactory = FeedCellFactory(photoDataProvider: photoDataProvider)
        let cellConfigurator = cellFactory.createConfigurator()

        return FeedViewDataSource(cellConfigurator: cellConfigurator)
    }
}
