//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import Foundation
import XCTest

let validPhotosData = """
{ "photos": { "page": 1, "pages": "65574", "perpage": 2, "total": "131147", 
    "photo": [
      { 
        "id": "49400452526", 
        "owner": "185722792@N05", 
        "secret": "e6a49de5e4", 
        "server": "65535", 
        "farm": 66, 
        "title": "Ford 6.4 Powerstroke EGR Delete Kit", 
        "ispublic": 1, 
        "isfriend": 0, 
        "isfamily": 0,
        "datetaken":"2020-11-27 17:30:40",
        "datetakengranularity":"0",
        "datetakenunknown":"0",
        "ownername":"owner1",
        "views":"1023",
        "tags":"tag1 tag2 tag3"
      },
      { 
        "id": "49400436126", 
        "owner": "53055234@N08", 
        "secret": "efb927e0b1", 
        "server": "65535", 
        "farm": 66, 
        "title": "BWO20V", 
        "ispublic": 1, 
        "isfriend": 0, 
        "isfamily": 0,
        "datetaken":"2020-12-24 12:25:40",
        "datetakengranularity":"0",
        "datetakenunknown":"0",
        "ownername":"owner2",
        "views":"20",
        "tags":"tag1 tag2 tag3"
      }
    ]
}}
""".data(using: .utf8)!

class FlickrPhotoServiceTests: XCTestCase {
    let expectationTimeout = 1.0

    var httpClientMock: MockHttpClient!
    var sut: FlickrPhotosService!

    let apiKey = "dummy_api_key"

    override func setUp() {
        super.setUp()

        httpClientMock = MockHttpClient()
        sut = FlickrPhotosService(apiKey: apiKey, httpClient: httpClientMock)
    }

    func test_getRecentPhotos_fetchesPhotos_withValidData_parsesPhotos() {
        httpClientMock.getResult = .success(validPhotosData)

        let fetchExpectation = XCTestExpectation(description: "Getting recent photos")

        var fetchedPhotos: [FlickrPhoto]!

        sut.getRecent(page: 1, photosPerPage: 1, includeMetadata: []) { result in
            switch result {
            case let .success(photos):
                fetchedPhotos = photos
                fetchExpectation.fulfill()
            case let .failure(error):
                XCTFail("Unexpected error while fetching photos: \(error)")
            }
        }

        wait(for: [fetchExpectation], timeout: expectationTimeout)

        XCTAssertEqual(httpClientMock.getCalls.count, 1)

        XCTAssertEqual(fetchedPhotos.count, 2)
        XCTAssertEqual(fetchedPhotos.map { $0.id }, ["49400452526", "49400436126"])
    }

    func test_getRecentPhotos_fetchesPhotos_withInvalidData_returnsError() {
        httpClientMock.getResult = .success("this is definitely not a valid json".data(using: .utf8)!)

        let fetchExpectation = XCTestExpectation(description: "Getting recent photos")

        var fetchError: Error?

        sut.getRecent(page: 1, photosPerPage: 1, includeMetadata: []) { result in
            switch result {
            case let .success(photos):
                XCTFail("Unexpected success while fetching photos: \(photos)")
            case let .failure(error):
                fetchError = error
                fetchExpectation.fulfill()
            }
        }

        wait(for: [fetchExpectation], timeout: expectationTimeout)

        XCTAssertEqual(httpClientMock.getCalls.count, 1)

        XCTAssertNotNil(fetchError)
    }
}
