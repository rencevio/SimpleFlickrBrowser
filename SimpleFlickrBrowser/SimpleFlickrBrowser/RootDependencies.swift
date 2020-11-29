//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

final class RootDependencies {
    private let photoDataProvider: PhotoDataProviding
    private let photoCollectionFetcher: PhotoCollectionFetching

    init() {
        let photoDataProviderFactory = PhotoDataProviderFactory()
        photoDataProvider = photoDataProviderFactory.createPhotoProvider()

        let photoCollectionFetcherFactory = FlickrCollectionFetcherFactory()
        photoCollectionFetcher = photoCollectionFetcherFactory.createCollectionFetcher(photoDataProvider: photoDataProvider)
    }

    func createFeedViewController() -> FeedViewController {
        let feedCellFactory = FeedCellFactory()
        let feedFactory = FeedFactory(feedCellFactory: feedCellFactory)

        return feedFactory.createViewController(
            photoDataProvider: photoDataProvider,
            photoCollectionFetcher: photoCollectionFetcher
        )
    }
}
