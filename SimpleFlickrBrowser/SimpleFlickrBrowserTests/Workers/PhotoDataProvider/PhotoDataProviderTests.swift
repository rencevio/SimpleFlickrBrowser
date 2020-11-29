//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import Foundation
import XCTest

class PhotoDataProviderTests: XCTestCase {
    let expectationTimeout = 1.0

    var cacheMock: MockPhotoDataCache!
    var retrieverMock: MockDataPhotoRetriever!
    var sut: PhotoDataProvider!

    override func setUp() {
        cacheMock = MockPhotoDataCache()
        retrieverMock = MockDataPhotoRetriever()

        sut = PhotoDataProvider(cache: cacheMock, retriever: retrieverMock)
    }

    func test_photoIsCached_getPhoto_returnsCachedPhoto() {
        let url = URL(string: "www.not-a-website.com")!

        let cachedData = Data()
        cacheMock.retrieveResult = .success(cachedData)

        let fetchExpectation = XCTestExpectation(description: "Fetching photo")

        sut.getPhotoData(from: url, backgroundDownload: false) { result in
            switch result {
            case let .success(data):
                XCTAssertEqual(cachedData, data)
            case let .failure(error):
                XCTFail("Unexpected error while fetching photo: \(error)")
            }

            fetchExpectation.fulfill()
        }

        wait(for: [fetchExpectation], timeout: expectationTimeout)

        XCTAssertEqual(cacheMock.storeCalls.count, 0)
        XCTAssertEqual(cacheMock.retrieveCalls, [url])

        XCTAssertEqual(retrieverMock.retrieveCalls.count, 0)
    }

    func test_photoIsNotCached_getPhoto_retrievesPhoto_storesPhotoInCache() {
        let url = URL(string: "www.not-a-website.com")!

        cacheMock.retrieveResult = .failure(.nothingStored)

        let retrievedData = Data()
        retrieverMock.retrieveResult = .success(retrievedData)

        let fetchExpectation = XCTestExpectation(description: "Fetching photo")

        sut.getPhotoData(from: url, backgroundDownload: false) { result in
            switch result {
            case let .success(data):
                XCTAssertEqual(retrievedData, data)
            case let .failure(error):
                XCTFail("Unexpected error while fetching photo: \(error)")
            }

            fetchExpectation.fulfill()
        }

        wait(for: [fetchExpectation], timeout: expectationTimeout)

        XCTAssertEqual(retrieverMock.retrieveCalls, [url])

        XCTAssertEqual(cacheMock.retrieveCalls, [url])
        XCTAssertEqual(cacheMock.storeCalls.count, 1)
        XCTAssertTrue(cacheMock.storeCalls[0] == (url, retrievedData))
    }
}
