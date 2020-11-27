//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol PhotoCollectionFetcherCreating {
    func createCollectionFetcher(photoDataProvider: PhotoDataProviding) -> PhotoCollectionFetching
}
