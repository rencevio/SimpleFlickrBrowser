//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import XCTest

class BrowserPresenterTests: XCTestCase {
    var displayingMock: MockBrowserDisplaying!

    var sut: BrowserPresenter!

    override func setUp() {
        super.setUp()

        displayingMock = MockBrowserDisplaying()

        sut = BrowserPresenter()
        sut.view = displayingMock
    }

    func test_presentPhotos_startingFromZero_dataIsReset() {
        let photo = Photo(id: "id", imageURL: URL(string: "www.not-a-website.com")!)

        sut.present(photos: BrowserModels.Photos.Response(startingPosition: 0, photos: [photo]))

        XCTAssertEqual(displayingMock.displayMorePhotosCalls.count, 0)
        XCTAssertEqual(displayingMock.displayNewPhotosCalls.count, 1)
    }

    func test_presentPhotosTwice_startingFromNonZero_dataIsUpdated() {
        let photo = Photo(id: "id", imageURL: URL(string: "www.not-a-website.com")!)

        sut.present(photos: BrowserModels.Photos.Response(startingPosition: 1, photos: [photo]))

        XCTAssertEqual(displayingMock.displayMorePhotosCalls.count, 1)
        XCTAssertEqual(displayingMock.displayNewPhotosCalls.count, 0)
    }
}
