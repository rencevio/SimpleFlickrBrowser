//
// Created by Maxim Berezhnoy on 27/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation.NSData

final class FlickrCollectionDataFetcher: FlickrCollectionDataFetching {
    let dataProvider: PhotoDataProviding;

    private let operatingQueue = DispatchQueue(label: "\(FlickrCollectionDataFetcher.self)OperatingQueue")

    init(dataProvider: PhotoDataProviding) {
        self.dataProvider = dataProvider
    }

    // Completes with dictionary containing only successfully retrieved data for photos  
    func fetchData(
            photos: [FlickrPhoto],
            withSize size: PhotoParameters.Size, 
            _ completion: @escaping ([Photo.ID: Foundation.Data]) -> ()) {
        var photosToFetch = Set(photos.map { $0.id })
        var photosImageData = [Photo.ID: Data]()

        photos.forEach { photo in
            let imageURL = FlickrPhotoURLResolver.resolveUrl(for: photo, withSize: size)

            dataProvider.getPhotoData(from: imageURL) { [operatingQueue] result in
                operatingQueue.async {
                    switch result {
                    case let .success(data):
                        photosImageData[photo.id] = data
                    case let .failure(error):
                        print("Failed to retrieve data for photo \(imageURL): \(error)")
                    }

                    photosToFetch.remove(photo.id)
                    
                    if photosToFetch.isEmpty {
                        completion(photosImageData)
                    }
                }
            }
        }
    }
}