//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import XCTest

class FeedInteractorTests: XCTestCase {
    var presenterMock: MockFeedPresenter!
    var collectionFetcherMock: MockPhotoCollectionFetcher!

    var sut: FeedInteractor!

    override func setUp() {
        super.setUp()

        presenterMock = MockFeedPresenter()
        collectionFetcherMock = MockPhotoCollectionFetcher()

        sut = FeedInteractor(presenter: presenterMock, photoCollectionFetcher: collectionFetcherMock)
    }

    func test_fetch_fetchAgainImmediatelyWithSameParams_fetchesAndPresentsOnlyOnce() {
        let fetchRequest = FeedModels.Photos.Request(startFromPosition: 0, fetchAtMost: 10, size: .large, metadata: [])

        collectionFetcherMock.fetchPhotoResult = .success([])

        sut.fetch(photos: fetchRequest)
        sut.fetch(photos: fetchRequest)

        awaitMainQueueResolution()

        XCTAssertEqual(presenterMock.presentPhotosCalls.count, 1)
        XCTAssertEqual(collectionFetcherMock.fetchPhotosCalls.count, 1)
    }

    func test_fetch_fetchAgainAfterFirstRequestFinished_fetchesAndPresentsTwice() {
        let fetchRequest = FeedModels.Photos.Request(startFromPosition: 0, fetchAtMost: 10, size: .large, metadata: [])

        collectionFetcherMock.fetchPhotoResult = .success([])

        sut.fetch(photos: fetchRequest)
        awaitMainQueueResolution()

        sut.fetch(photos: fetchRequest)
        awaitMainQueueResolution()

        XCTAssertEqual(presenterMock.presentPhotosCalls.count, 2)
        XCTAssertEqual(collectionFetcherMock.fetchPhotosCalls.count, 2)
    }
}
