//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import Foundation

class MockDataPhotoRetriever: PhotoDataRetrieving {
    var retrieveCalls = [URL]()
    var retrieveResult: Result<Data, Error>?

    func retrieve(from url: URL, backgroundDownload _: Bool, completion: @escaping Completion) {
        guard let result = retrieveResult else {
            fatalError("\(#function) expectation was not set")
        }

        retrieveCalls.append(url)

        completion(result)
    }
}
