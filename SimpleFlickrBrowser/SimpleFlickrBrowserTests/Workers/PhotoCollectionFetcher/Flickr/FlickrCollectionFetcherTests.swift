//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import XCTest

class FlickrCollectionFetcherTests: XCTestCase {
    let expectationTimeout = 1.0

    var photosServiceMock: MockFlickrPhotosService!
    var collectionDataFetcherMock: MockFlickrCollectionDataFetcher!
    var sut: FlickrCollectionFetcher!

    override func setUp() {
        super.setUp()

        photosServiceMock = MockFlickrPhotosService()
        collectionDataFetcherMock = MockFlickrCollectionDataFetcher()
        sut = FlickrCollectionFetcher(flickrPhotosService: photosServiceMock, collectionDataFetcher: collectionDataFetcherMock)
    }

    func test_fetchPhotos_fetchesRecentPhotos() {
        let serviceFetchResult = [
            FlickrPhoto(id: "1", secret: "1", server: "1", farm: 1, datetaken: "2020-11-22 21:21:29", ownername: "1", views: "1", tags: "1"),
            FlickrPhoto(id: "2", secret: "2", server: "2", farm: 2, datetaken: "2012-10-20 04:02:01", ownername: "2", views: "2", tags: "2"),
        ]

        let collectionDataFetchResult = Dictionary(uniqueKeysWithValues: serviceFetchResult.map { ($0.id, Data()) })

        let startingPosition = 0
        let maxFetchCount = 50
        let photoSize = PhotoParameters.Size.large

        let fetchExpectation = XCTestExpectation(description: "Fetching photos")
        var fetchResult: [Photo]!

        photosServiceMock.getRecentResult = .success(serviceFetchResult)
        collectionDataFetcherMock.fetchDataResult = collectionDataFetchResult

        sut.fetchPhotos(startingFrom: startingPosition, fetchAtMost: maxFetchCount, withSize: photoSize) { result in
            switch result {
            case let .success(photos):
                fetchResult = photos
                fetchExpectation.fulfill()
            case let .failure(error):
                XCTFail("Unexpected error while fetching photos: \(error)")
            }
        }

        wait(for: [fetchExpectation], timeout: expectationTimeout)

        XCTAssertEqual(serviceFetchResult.map { $0.id }, fetchResult.map { $0.id })

        XCTAssertEqual(photosServiceMock.getRecentCalls.count, 1)
        XCTAssertTrue(photosServiceMock.getRecentCalls[0] == (startingPosition + 1, maxFetchCount))

        XCTAssertEqual(collectionDataFetcherMock.fetchDataCalls.count, 1)
    }

    func test_fetchPhotos_correctlyConvertsMetadata() {
        let flickrPhoto = FlickrPhoto(id: "1", secret: "1", server: "1", farm: 1, datetaken: "2020-11-22 21:21:29", ownername: "1", views: "1", tags: "1")

        let collectionDataFetchResult = [flickrPhoto.id: Data()]

        let startingPosition = 0
        let maxFetchCount = 50

        let fetchExpectation = XCTestExpectation(description: "Fetching photos")
        var fetchResult: [Photo]!

        photosServiceMock.getRecentResult = .success([flickrPhoto])
        collectionDataFetcherMock.fetchDataResult = collectionDataFetchResult

        sut.fetchPhotos(startingFrom: startingPosition, fetchAtMost: maxFetchCount, withSize: .large) { result in
            switch result {
            case let .success(photos):
                fetchResult = photos
                fetchExpectation.fulfill()
            case let .failure(error):
                XCTFail("Unexpected error while fetching photos: \(error)")
            }
        }

        wait(for: [fetchExpectation], timeout: expectationTimeout)

        XCTAssertEqual(fetchResult.count, 1)

        let metadata = fetchResult[0].metadata
        XCTAssertNotNil(metadata.dateTaken)
        XCTAssertEqual(metadata.views, flickrPhoto.views.toInt()!)
    }
}
