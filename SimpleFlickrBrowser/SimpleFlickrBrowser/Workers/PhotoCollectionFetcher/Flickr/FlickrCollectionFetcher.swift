//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation.NSDateFormatter

final class FlickrCollectionFetcher: PhotoCollectionFetching {
    private let flickrPhotosService: FlickrPhotosFetching

    init(flickrPhotosService: FlickrPhotosFetching) {
        self.flickrPhotosService = flickrPhotosService
    }

    func fetchPhotos(startingFrom position: Int,
                     fetchAtMost maxFetchCount: Int,
                     withSize size: PhotoParameters.Size,
                     includeMetadata metadata: [PhotoParameters.Metadata],
                     completion: @escaping Completion) {
        fetchPhotos(startingFrom: position, fetchAtMost: maxFetchCount, matching: nil, withSize: size, includeMetadata: metadata, completion: completion)
    }

    func fetchPhotos(startingFrom position: Int,
                     fetchAtMost maxFetchCount: Int,
                     matching searchCriteria: String?,
                     withSize size: PhotoParameters.Size,
                     includeMetadata metadata: [PhotoParameters.Metadata],
                     completion: @escaping Completion) {
        let page = position / maxFetchCount + 1

        if let searchCriteria = searchCriteria, !searchCriteria.isEmpty {
            flickrPhotosService.search(
                    matching: searchCriteria,
                    page: page,
                    photosPerPage: maxFetchCount,
                    includeMetadata: metadata,
                    completion: transformFetchResult(withSize: size, completion)
            )
        } else {
            flickrPhotosService.getRecent(
                    page: page,
                    photosPerPage: maxFetchCount,
                    includeMetadata: metadata,
                    completion: transformFetchResult(withSize: size, completion)
            )
        }
    }

    private func transformFetchResult(withSize size: PhotoParameters.Size, _ completion: @escaping Completion) -> FlickrPhotosService.Completion {
        { result in
            switch result {
            case let .success(photos):
                completion(.success(photos.map { photo in
                    Photo(id: photo.id,
                            imageURL: FlickrPhotoURLResolver.resolveUrl(
                                    for: photo,
                                    withSize: size
                            ),
                            metadata: extractMetadata(from: photo)
                    )
                }))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

private func extractMetadata(from photo: FlickrPhoto) -> Photo.Metadata {
    let dateTakenFormatter = DateFormatter()
    dateTakenFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    
    return Photo.Metadata(
            views: photo.views?.toInt(), 
            tags: photo.tags?.components(separatedBy: " "), 
            ownerName: photo.ownername, 
            dateTaken: photo.datetaken?.toDate(formatter: dateTakenFormatter)
    )
}
