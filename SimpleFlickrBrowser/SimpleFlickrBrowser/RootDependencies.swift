//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

final class RootDependencies {
    let photoDataProvider: PhotoDataProviding

    init() {
        let photoDataProviderFactory = PhotoDataProviderFactory()
        self.photoDataProvider = photoDataProviderFactory.createPhotoProvider()
    }

    func createBrowserViewController() -> BrowserViewController {
        let browserFactory = BrowserFactory(photoDataProvider: photoDataProvider)

        return browserFactory.createViewController(photoDataProvider: photoDataProvider)
    }
}