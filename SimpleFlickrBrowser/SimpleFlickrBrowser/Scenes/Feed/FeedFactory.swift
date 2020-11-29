//
// Created by Maxim Berezhnoy on 23/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol FeedCreating {
    func createViewController(photoDataProvider: PhotoDataProviding, photoCollectionFetcher: PhotoCollectionFetching) -> FeedViewController
}

final class FeedFactory: FeedCreating {
    let feedCellFactory: FeedCellCreating

    init(feedCellFactory: FeedCellCreating) { 
        self.feedCellFactory = feedCellFactory 
    }

    func createViewController(photoDataProvider: PhotoDataProviding, photoCollectionFetcher: PhotoCollectionFetching) -> FeedViewController {
        let presenter = FeedPresenter()
        let interactor = FeedInteractor(presenter: presenter, photoCollectionFetcher: photoCollectionFetcher)
        var router = createRouter(photoDataProvider: photoDataProvider)
        let dataSource = createDataSource(router: router)

        let viewController = FeedViewController(
                interactor: interactor, 
                dataSource: dataSource, 
                router: router
        )

        presenter.view = viewController
        router.sourceVC = viewController

        return viewController
    }

    private func createDataSource(router: FeedRouting) -> FeedDataSourcing {
        let configurator = feedCellFactory.createFeedCellConfigurator(feedRouter: router)
        
        return FeedViewDataSource(feedCellConfigurator: configurator)
    }

    private func createRouter(photoDataProvider: PhotoDataProviding) -> FeedRouting {
        let fullImageFactory = FullImageFactory(photoDataProvider: photoDataProvider)

        return FeedRouter(fullImageFactory: fullImageFactory)
    }
}
