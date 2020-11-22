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
        case page
        case perPage = "per_page"
        case method
        case apiKey = "api_key"
        case format
        case text
        case noJsonCallback = "nojsoncallback"
        case extras
    }

    enum PhotoSizeSuffix: String {
        case thumbSquare = "q"
        case medium = "c"
        case large = "b"
    }
    
    enum PhotoMetadata: String {
        case views
        case tags
        case ownerName = "owner_name"
        case dateTaken = "date_taken"
    }
}
