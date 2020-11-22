//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

final class FlickrCollectionFetcher: PhotoCollectionFetching {
    private let flickrPhotosService: FlickrPhotosFetching

    init(flickrPhotosService: FlickrPhotosFetching) {
        self.flickrPhotosService = flickrPhotosService
    }

    func fetchPhotos(startingFrom position: Int,
                     fetchAtMost maxFetchCount: Int,
                     withSize size: PhotoSize,
                     completion: @escaping Completion) {
        fetchPhotos(startingFrom: position, fetchAtMost: maxFetchCount, matching: nil, withSize: size, completion: completion)
    }

    func fetchPhotos(startingFrom position: Int,
                     fetchAtMost maxFetchCount: Int,
                     matching searchCriteria: String?,
                     withSize size: PhotoSize,
                     completion: @escaping Completion) {
        let page = position / maxFetchCount + 1

        if let searchCriteria = searchCriteria, !searchCriteria.isEmpty {
            flickrPhotosService.search(
                    matching: searchCriteria,
                    page: page,
                    photosPerPage: maxFetchCount,
                    completion: transformFetchResult(withSize: size, completion)
            )
        } else {
            flickrPhotosService.getRecent(
                    page: page,
                    photosPerPage: maxFetchCount,
                    completion: transformFetchResult(withSize: size, completion)
            )
        }
    }

    private func transformFetchResult(withSize size: PhotoSize, _ completion: @escaping Completion) -> FlickrPhotosService.Completion {
        { result in
            switch result {
            case let .success(photos):
                completion(.success(photos.map { Photo(id: $0.id, imageURL: FlickrPhotoURLResolver.resolveUrl(for: $0, withSize: size)) }))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
