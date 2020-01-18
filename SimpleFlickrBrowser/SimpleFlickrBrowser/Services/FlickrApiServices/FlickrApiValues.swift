//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

enum FlickrApiValues {
    enum Method: String {
        case photosGetRecent = "flickr.photos.getRecent"
        case photosSearch = "flickr.photos.search"
    }

    enum QueryParameter: String {
        case page = "page"
        case perPage = "perpage"
        case method = "method"
        case apiKey = "api_key"
        case format = "format"
        case text = "text"
        case noJsonCallback = "nojsoncallback"
    }
}