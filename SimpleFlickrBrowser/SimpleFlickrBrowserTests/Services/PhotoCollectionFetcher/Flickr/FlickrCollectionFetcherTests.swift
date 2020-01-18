//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import XCTest

class FlickrCollectionFetcherTests: XCTestCase {
    let expectationTimeout = 1.0

    var photosServiceMock: MockFlickrPhotosService!
    var sut: FlickrCollectionFetcher!

    override func setUp() {
        super.setUp()

        photosServiceMock = MockFlickrPhotosService()
        sut = FlickrCollectionFetcher(flickrPhotosService: photosServiceMock)
    }

    func test_fetchPhotos_withoutSearchCriteria_fetchesRecentPhotos() {
        let serviceFetchResult = [
            FlickrPhoto(id: "1", secret: "1", server: "1", farm: 1),
            FlickrPhoto(id: "2", secret: "2", server: "2", farm: 2),
        ]

        let startingPosition = 0
        let maxFetchCount = 50

        let fetchExpectation = XCTestExpectation(description: "Fetching photos")
        var fetchResult: [Photo]!

        photosServiceMock.getRecentResult = .success(serviceFetchResult)

        sut.fetchPhotos(startingFrom: startingPosition, fetchAtMost: maxFetchCount) { result in
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

        XCTAssertEqual(photosServiceMock.searchCalls.count, 0)
    }

    func test_fetchPhotos_withSearchCriteria_searchesForPhotos() {
        let serviceFetchResult = [
            FlickrPhoto(id: "1", secret: "1", server: "1", farm: 1),
            FlickrPhoto(id: "2", secret: "2", server: "2", farm: 2),
        ]

        let searchCriteria = "cars"
        let startingPosition = 0
        let maxFetchCount = 50

        let fetchExpectation = XCTestExpectation(description: "Fetching photos")
        var fetchResult: [Photo]!

        photosServiceMock.searchResult = .success(serviceFetchResult)

        sut.fetchPhotos(
            startingFrom: startingPosition,
            fetchAtMost: maxFetchCount,
            matching: searchCriteria
        ) { result in
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

        XCTAssertEqual(photosServiceMock.searchCalls.count, 1)
        XCTAssertTrue(photosServiceMock.searchCalls[0] == (searchCriteria, startingPosition + 1, maxFetchCount))

        XCTAssertEqual(photosServiceMock.getRecentCalls.count, 0)
    }
}
