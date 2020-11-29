//
// Created by Maxim Berezhnoy on 29/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import Foundation.NSData

class MockFlickrCollectionDataFetcher: FlickrCollectionDataFetching {
    var fetchDataCalls = [([FlickrPhoto], PhotoParameters.Size)]()
    var fetchDataResult: [Photo.ID: Data]!
    
    func fetchData(photos: [FlickrPhoto], withSize size: PhotoParameters.Size, _ completion: @escaping ([Photo.ID: Data]) -> Void) {
        guard let result = fetchDataResult else {
            fatalError("\(#function) expectation was not set")
        }
        
        fetchDataCalls.append((photos, size))
        
        completion(result)
    }
}