//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol PhotoDataProviderCreating {
    func createPhotoProvider() -> PhotoDataProviding
}

final class PhotoDataProviderFactory: PhotoDataProviderCreating {
    func createPhotoProvider() -> PhotoDataProviding {
        let cache = PhotoDataNSCache()

        let httpClient = Http.Client()
        let retriever = NetworkPhotoDataRetriever(httpClient: httpClient)

        return PhotoDataProvider(cache: cache, retriever: retriever)
    }
}