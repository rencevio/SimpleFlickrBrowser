//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import XCTest

class MockPhotoCollectionFetcher: PhotoCollectionFetching {
    var fetchPhotosCalls = [(Int, Int, String?)]()
    var fetchPhotoResult: Result<[Photo], Error>!
    
    func fetchPhotos(startingFrom position: Int, 
                     fetchAtMost maxFetchCount: Int, 
                     matching searchCriteria: String?, 
                     completion: @escaping Completion) {
        guard let result = fetchPhotoResult else {
            fatalError("\(#function) expectation was not set")
        }
        
        fetchPhotosCalls.append((position, maxFetchCount, searchCriteria))
        
        completion(result)
    }
}