//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import struct Foundation.URL

final class FlickrPhotoURLResolver {
    static func resolveUrl(for photo: FlickrPhoto) -> URL {
        guard let url = URL(string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_q.jpg")
        else {
            fatalError("Failed to resolve flickr photo url (input photo: \(photo))")
        }

        return url
    }
}
