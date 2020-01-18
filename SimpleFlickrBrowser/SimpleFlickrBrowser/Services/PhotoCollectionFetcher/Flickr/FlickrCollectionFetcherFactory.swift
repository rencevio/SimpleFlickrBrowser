//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.


final class FlickrCollectionFetcherFactory: PhotoCollectionFetcherCreating {
    func createCollectionFetcher() -> PhotoCollectionFetching {
        let httpClient = Http.Client()
        let flickrPhotosService = FlickrPhotosService(apiKey: flickrApiKey, httpClient: httpClient)

        let fetcher = FlickrCollectionFetcher(flickrPhotosService: flickrPhotosService)

        return fetcher
    }
}