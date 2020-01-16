//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

final class BrowserFactory {
    func createBrowserViewController() -> BrowserViewController {
        let presenter = BrowserPresenter()
        let interactor = BrowserInteractor(presenter: presenter)
        let dataSource = BrowserViewDataSource()
        let viewController = BrowserViewController(interactor: interactor, dataSource: dataSource)

        presenter.view = viewController

        return viewController
    }
}