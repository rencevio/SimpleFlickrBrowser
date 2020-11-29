//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import Foundation

final class MockPhotoDataProvider: PhotoDataProviding {
    var getPhotoDataCalls = [URL]()
    var getPhotoDataResults = [Result<Data, Error>]()

    func getPhotoData(from url: URL, backgroundDownload: Bool, _ completion: @escaping Completion) {
        guard !getPhotoDataResults.isEmpty else {
            fatalError("\(#function) expectation was not set")
        }

        getPhotoDataCalls.append(url)

        completion(getPhotoDataResults.popLast()!)
    }
}
