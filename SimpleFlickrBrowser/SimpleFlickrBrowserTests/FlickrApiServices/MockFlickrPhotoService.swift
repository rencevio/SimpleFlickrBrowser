//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

class MockFlickrPhotosService: FlickrPhotosFetching {
    var getRecentCalls = [(Int, Int)]()
    var getRecentResult: Result<[FlickrPhoto], Error>?

    var searchCalls = [(String, Int, Int)]()
    var searchResult: Result<[FlickrPhoto], Error>?

    func getRecent(page: Int, photosPerPage: Int, completion: @escaping Completion) {
        guard let result = getRecentResult else {
            fatalError("\(#function) expectation was not set")
        }

        getRecentCalls.append((page, photosPerPage))

        completion(result)
    }

    func search(matching text: String, page: Int, photosPerPage: Int, completion: @escaping Completion) {
        guard let result = searchResult else {
            fatalError("\(#function) expectation was not set")
        }

        searchCalls.append((text, page, photosPerPage))

        completion(result)
    }
}