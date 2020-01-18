//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

enum FlickrApiValues {
    static let host = "www.flickr.com"
    static let path = "/services/rest"
    
    enum Method: String {
        case photosGetRecent = "flickr.photos.getRecent"
        case photosSearch = "flickr.photos.search"
    }

    enum QueryParameter: String {
        case page = "page"
        case perPage = "per_page"
        case method = "method"
        case apiKey = "api_key"
        case format = "format"
        case text = "text"
        case noJsonCallback = "nojsoncallback"
    }
}