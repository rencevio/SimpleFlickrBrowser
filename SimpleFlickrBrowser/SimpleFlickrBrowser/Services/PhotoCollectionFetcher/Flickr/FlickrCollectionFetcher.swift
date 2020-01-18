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
                     completion: @escaping Completion) {
        fetchPhotos(startingFrom: position, fetchAtMost: maxFetchCount, matching: nil, completion: completion)
    }

    func fetchPhotos(startingFrom position: Int,
                     fetchAtMost maxFetchCount: Int,
                     matching searchCriteria: String?,
                     completion: @escaping Completion) {
        let page = position / maxFetchCount

        if let searchCriteria = searchCriteria {
            flickrPhotosService.search(
                    matching: searchCriteria,
                    page: page,
                    photosPerPage: maxFetchCount,
                    completion: transformFetchResult(completion)
            )
        } else {
            flickrPhotosService.getRecent(
                    page: page,
                    photosPerPage: maxFetchCount,
                    completion: transformFetchResult(completion)
            )
        }
    }

    private func transformFetchResult(_ completion: @escaping Completion) -> FlickrPhotosService.Completion {
        { result in
            switch result {
            case .success(let photos):
                completion(.success(photos.map { Photo(id: $0.id, image: FlickrPhotoURLResolver.resolveUrl(for: $0)) }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}