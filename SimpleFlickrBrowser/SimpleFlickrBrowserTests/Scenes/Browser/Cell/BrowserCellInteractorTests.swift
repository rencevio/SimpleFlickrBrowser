//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import XCTest

class BrowserCellInteractorTests: XCTestCase {
    var presenter: MockBrowserCellPresenter!
    var photoDataProvider: MockPhotoDataProvider!
    var sut: BrowserCellInteractor!

    override func setUp() {
        super.setUp()

        presenter = MockBrowserCellPresenter()
        photoDataProvider = MockPhotoDataProvider()

        sut = BrowserCellInteractor(presenter: presenter, photoDataProvider: photoDataProvider)
    }
    
    func test_fetchImage_retrievesFromProvider_success_sendsDataToPresenter() {
        let url = URL(string: "www.not-a-website.com")!
        let photoData = Data()
        
        photoDataProvider.getPhotoDataResult = .success(photoData)
        
        sut.fetch(image: PhotoImage.Request(url: url))
        
        awaitMainQueueResolution()
        
        XCTAssertEqual(photoDataProvider.getPhotoDataCalls, [url])
        
        XCTAssertEqual(presenter.presentCalls.map { $0.data }, [photoData])
        XCTAssertEqual(presenter.presentErrorCalls, 0)
    }
    
    func test_fetchImage_retrievesFromProvider_failure_sendsErrorToPresenter() {
        let url = URL(string: "www.not-a-website.com")!
        
        enum RetrievalError: Error {
            case undefined    
        }

        photoDataProvider.getPhotoDataResult = .failure(RetrievalError.undefined)

        sut.fetch(image: PhotoImage.Request(url: url))

        awaitMainQueueResolution()

        XCTAssertEqual(photoDataProvider.getPhotoDataCalls, [url])

        XCTAssertEqual(presenter.presentCalls.count, 0)
        XCTAssertEqual(presenter.presentErrorCalls, 1)
    }
}
