//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

final class RootDependencies {
    let photoDataProvider: PhotoDataProviding
    let photoCollectionFetcher: PhotoCollectionFetching

    init() {
        let photoDataProviderFactory = PhotoDataProviderFactory()
        photoDataProvider = photoDataProviderFactory.createPhotoProvider()

        let photoCollectionFetcherFactory = FlickrCollectionFetcherFactory()
        photoCollectionFetcher = photoCollectionFetcherFactory.createCollectionFetcher()
    }

    func createBrowserViewController() -> BrowserViewController {
        let browserFactory = BrowserFactory()

        return browserFactory.createViewController(
            photoDataProvider: photoDataProvider,
            photoCollectionFetcher: photoCollectionFetcher
        )
    }
}
