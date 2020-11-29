//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import XCTest

class MockPhotoCollectionFetcher: PhotoCollectionFetching {
    var fetchPhotosCalls = [(Int, Int, PhotoParameters.Size)]()
    var fetchPhotoResult: Result<[Photo], Error>!

    func fetchPhotos(startingFrom position: Int,
                     fetchAtMost maxFetchCount: Int,
                     withSize size: PhotoParameters.Size,
                     completion: @escaping Completion) {
        guard let result = fetchPhotoResult else {
            fatalError("\(#function) expectation was not set")
        }

        fetchPhotosCalls.append((position, maxFetchCount, size))

        completion(result)
    }
}
