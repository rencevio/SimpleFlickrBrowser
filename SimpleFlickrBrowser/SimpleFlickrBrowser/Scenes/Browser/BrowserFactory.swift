//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

final class BrowserFactory {
    func createViewController(photoDataProvider: PhotoDataProviding,
                              photoCollectionFetcher: PhotoCollectionFetching) -> BrowserViewController {
        let presenter = BrowserPresenter()
        let interactor = BrowserInteractor(presenter: presenter, photoCollectionFetcher: photoCollectionFetcher)

        let dataSource = createDataSource(photoDataProvider: photoDataProvider)

        let viewController = BrowserViewController(interactor: interactor, dataSource: dataSource)

        presenter.view = viewController

        return viewController
    }

    private func createDataSource(photoDataProvider: PhotoDataProviding) -> BrowserDataSourcing {
        let cellFactory = BrowserCellFactory(photoDataProvider: photoDataProvider)
        let cellConfigurator = cellFactory.createConfigurator()

        return BrowserViewDataSource(cellConfigurator: cellConfigurator)
    }
}