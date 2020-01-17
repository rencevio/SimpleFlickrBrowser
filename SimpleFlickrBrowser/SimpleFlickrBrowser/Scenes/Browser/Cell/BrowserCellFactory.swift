//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol BrowserCellCreating {
    func createConfigurator() -> BrowserCellConfiguring
}

final class BrowserCellFactory: BrowserCellCreating {
    let photoDataProvider: PhotoDataProviding

    init(photoDataProvider: PhotoDataProviding) {
        self.photoDataProvider = photoDataProvider
    }

    func createConfigurator() -> BrowserCellConfiguring {
        BrowserCellConfigurator(photoDataProvider: photoDataProvider)
    }
}