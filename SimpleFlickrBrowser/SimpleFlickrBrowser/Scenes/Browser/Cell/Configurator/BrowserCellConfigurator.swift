//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol BrowserCellConfiguring {
    func configure(cell: ConfigurableBrowserCell, with photo: Photo)
}

final class BrowserCellConfigurator: BrowserCellConfiguring {
    let photoDataProvider: PhotoDataProviding

    init(photoDataProvider: PhotoDataProviding) {
        self.photoDataProvider = photoDataProvider
    }

    func configure(cell: ConfigurableBrowserCell, with photo: Photo) {
        let presenter = BrowserCellPresenter()
        let interactor = BrowserCellInteractor(presenter: presenter, photoDataProvider: photoDataProvider)

        presenter.view = cell

        cell.configure(interactor: interactor, photo: photo)
    }
}