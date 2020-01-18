//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import Foundation

class MockHttpClient: HttpCommunicator {
    var getCalls = [URL]()
    var getResult: Result<Data, Http.RequestError>!

    func get(url: URL, completion: @escaping Completion) {
        guard let result = getResult else {
            fatalError("\(#function) expectation was not set")
        }

        getCalls.append(url)

        completion(result)
    }
} 