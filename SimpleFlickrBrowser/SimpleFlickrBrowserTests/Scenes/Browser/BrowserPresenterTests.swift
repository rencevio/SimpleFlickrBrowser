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

    func test_presentPhotosTwice_withDifferentSearchCriteria_dataIsReset() {
        let photo = Photo(id: "id", image: URL(string: "www.not-a-website.com")!)

        sut.present(photos: Photos.Response(searchCriteria: "", photos: [photo]))
        sut.present(photos: Photos.Response(searchCriteria: "second", photos: [photo]))

        XCTAssertEqual(displayingMock.displayMorePhotosCalls.count, 1)
        XCTAssertEqual(displayingMock.displayNewPhotosCalls.count, 1)
    }
}
