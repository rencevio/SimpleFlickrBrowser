//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

final class FlickrCollectionFetcherFactory: PhotoCollectionFetcherCreating {
    func createCollectionFetcher(photoDataProvider: PhotoDataProviding) -> PhotoCollectionFetching {
        let httpClient = Http.Client()
        let flickrPhotosService = FlickrPhotosService(apiKey: flickrApiKey, httpClient: httpClient)
        let collectionDataFetcher = FlickrCollectionDataFetcher(dataProvider: photoDataProvider)

        let fetcher = FlickrCollectionFetcher(
                flickrPhotosService: flickrPhotosService, 
                collectionDataFetcher: collectionDataFetcher
        )

        return fetcher
    }
}
