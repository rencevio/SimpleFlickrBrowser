//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import struct Foundation.URL

final class FlickrPhotoURLResolver {
    static func resolveUrl(for photo: FlickrPhoto, withSize size: PhotoParameters.Size) -> URL {
        let sizeSuffix = getSizeSuffix(for: size)

        guard let url = URL(string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_\(sizeSuffix.rawValue).jpg")
                else {
            fatalError("Failed to resolve flickr photo url (input photo: \(photo))")
        }

        return url
    }

    private static func getSizeSuffix(for size: PhotoParameters.Size) -> FlickrApiValues.PhotoSizeSuffix {
        switch (size) {
        case .thumbSquare:
            return .thumbSquare
        case .medium:
            return .medium
        case .large:
            return .large
        }
    }
}
