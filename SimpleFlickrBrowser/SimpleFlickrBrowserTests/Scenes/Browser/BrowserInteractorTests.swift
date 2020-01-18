//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import XCTest

class BrowserInteractorTests: XCTestCase {
    var presenterMock: MockBrowserPresenter!
    var collectionFetcherMock: MockPhotoCollectionFetcher!
    
    var sut: BrowserInteractor!

    override func setUp() {
        super.setUp()
    
        presenterMock = MockBrowserPresenter()
        collectionFetcherMock = MockPhotoCollectionFetcher()
        
        sut = BrowserInteractor(presenter: presenterMock, photoCollectionFetcher: collectionFetcherMock)
    }
    
    func test_fetchTwiceWithSameParams_fetchesAndPresentsOnlyOnce() {
        let fetchRequest = Photos.Request(startFromPosition: 0, fetchAtMost: 10, searchCriteria: "42")
        
        collectionFetcherMock.fetchPhotoResult = .success([])
        
        sut.fetch(photos: fetchRequest)
        sut.fetch(photos: fetchRequest)
        
        awaitMainQueueResolution()
        
        XCTAssertEqual(presenterMock.presentPhotosCalls.count, 1)
        XCTAssertEqual(collectionFetcherMock.fetchPhotosCalls.count, 1)
    }
}