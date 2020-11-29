//
// Created by Maxim Berezhnoy on 29/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import XCTest

class FlickrCollectionDataFetcherTests: XCTestCase {
    let expectationTimeout = 1.0

    var dataProviderMock: MockPhotoDataProvider!
    var sut: FlickrCollectionDataFetcher!

    override func setUp() {
        super.setUp()

        dataProviderMock = MockPhotoDataProvider()
        sut = FlickrCollectionDataFetcher(dataProvider: dataProviderMock)
    }

    func test_fetchData_somePhotosHaveNoImageData_returnsOnlyPhotosWithData() {
        let photosWithData = [
            FlickrPhoto(id: "1", secret: "1", server: "1", farm: 1, datetaken: "1", ownername: "1", views: "1", tags: "1"),
            FlickrPhoto(id: "2", secret: "2", server: "2", farm: 2, datetaken: "2", ownername: "2", views: "2", tags: "2")
        ]
        let photosWithoutData = [
            FlickrPhoto(id: "3", secret: "3", server: "3", farm: 3, datetaken: "3", ownername: "3", views: "3", tags: "3"),
        ]

        let photoSize = PhotoParameters.Size.large

        photosWithoutData.forEach { _ in
            dataProviderMock.getPhotoDataResults.append(.failure(Http.RequestError.noData))
        }
        photosWithData.forEach { _ in
            dataProviderMock.getPhotoDataResults.append(.success(Data()))
        }

        let fetchExpectation = XCTestExpectation(description: "Fetching photos data")
        var fetchResult: [Photo.ID: Data]!

        sut.fetchData(photos: photosWithData + photosWithoutData, withSize: photoSize) { result in
            fetchResult = result
            fetchExpectation.fulfill()
        }

        wait(for: [fetchExpectation], timeout: expectationTimeout)

        XCTAssertEqual(fetchResult.count, photosWithData.count)
        XCTAssertEqual(fetchResult, Dictionary(uniqueKeysWithValues: photosWithData.map { ($0.id, Data()) }))
    }
}