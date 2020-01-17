//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

final class BrowserFactory {
    private let photoDataProvider: PhotoDataProviding

    init(photoDataProvider: PhotoDataProviding) {
        self.photoDataProvider = photoDataProvider
    }

    func createViewController(photoDataProvider: PhotoDataProviding) -> BrowserViewController {
        let presenter = BrowserPresenter()
        let interactor = BrowserInteractor(presenter: presenter)

        let dataSource = createDataSource()

        let viewController = BrowserViewController(interactor: interactor, dataSource: dataSource)

        presenter.view = viewController

        return viewController
    }

    private func createDataSource() -> BrowserDataSourcing {
        let cellFactory = BrowserCellFactory(photoDataProvider: photoDataProvider)
        let cellConfigurator = cellFactory.createConfigurator()

        return BrowserViewDataSource(cellConfigurator: cellConfigurator)
    }
}