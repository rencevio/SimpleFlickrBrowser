//
// Created by Maxim Berezhnoy on 23/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol FeedCreating {
    func createViewController(photoCollectionFetcher: PhotoCollectionFetching) -> FeedViewController
}

final class FeedFactory: FeedCreating {
    let feedCellFactory: FeedCellCreating

    init(feedCellFactory: FeedCellCreating) { 
        self.feedCellFactory = feedCellFactory 
    }

    func createViewController(photoCollectionFetcher: PhotoCollectionFetching) -> FeedViewController {
        let presenter = FeedPresenter()
        let interactor = FeedInteractor(presenter: presenter, photoCollectionFetcher: photoCollectionFetcher)
        let router = createRouter()
        let dataSource = createDataSource(router: router)

        let viewController = FeedViewController(
                interactor: interactor, 
                dataSource: dataSource, 
                router: router
        )

        presenter.view = viewController

        return viewController
    }

    private func createDataSource(router: FeedRouting) -> FeedDataSourcing {
        let configurator = feedCellFactory.createFeedCellConfigurator(feedRouter: router)
        
        return FeedViewDataSource(feedCellConfigurator: configurator)
    }

    private func createRouter() -> FeedRouting {
        let fullImageFactory = FullImageFactory()

        return FeedRouter(fullImageFactory: fullImageFactory)
    }
}
