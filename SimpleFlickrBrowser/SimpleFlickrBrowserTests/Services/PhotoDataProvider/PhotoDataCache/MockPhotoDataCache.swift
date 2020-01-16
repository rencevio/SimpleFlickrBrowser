//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import Foundation

class MockPhotoDataCache: PhotoDataCaching {
    var storeCalls = [(URL, Data)]()
    
    var retrieveCalls = [URL]()
    var retrieveResult: Result<Data, CacheError>?

    func store(data: Data, for url: URL) {
        storeCalls.append((url, data))
    }

    func retrieve(from url: URL) -> Result<Data, CacheError> {
        guard let result = retrieveResult else { fatalError("\(#function) expectation was not set") }
        
        retrieveCalls.append(url)
        
        return result
    }
}