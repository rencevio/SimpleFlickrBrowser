//
// Created by Maxim Berezhnoy on 29/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import Foundation
import XCTest

class BrowserCellInteractorTests: XCTestCase {
    var presenter: MockFullImagePresenter!
    var photoDataProvider: MockPhotoDataProvider!
    var sut: FullImageInteractor!

    override func setUp() {
        super.setUp()

        presenter = MockFullImagePresenter()
        photoDataProvider = MockPhotoDataProvider()

        sut = FullImageInteractor(presenter: presenter, photoDataProvider: photoDataProvider)
    }

    func test_fetchImage_retrievesFromProvider_success_sendsDataToPresenter() {
        let url = URL(string: "www.not-a-website.com")!
        let photoData = Data()

        photoDataProvider.getPhotoDataResults = [.success(photoData)]

        sut.fetch(image: FullImageModels.Image.Request(url: url))

        awaitMainQueueResolution()

        XCTAssertEqual(photoDataProvider.getPhotoDataCalls, [url])

        XCTAssertEqual(presenter.presentImageCalls.map { $0.image }, [photoData])
        XCTAssertEqual(presenter.presentErrorCalls, 0)
    }

    func test_fetchImage_retrievesFromProvider_failure_sendsErrorToPresenter() {
        let url = URL(string: "www.not-a-website.com")!

        enum RetrievalError: Error {
            case undefined
        }

        photoDataProvider.getPhotoDataResults = [.failure(RetrievalError.undefined)]

        sut.fetch(image: FullImageModels.Image.Request(url: url))

        awaitMainQueueResolution()

        XCTAssertEqual(photoDataProvider.getPhotoDataCalls, [url])

        XCTAssertEqual(presenter.presentImageCalls.count, 0)
        XCTAssertEqual(presenter.presentErrorCalls, 1)
    }
}
