//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation.NSDateFormatter

final class FlickrCollectionFetcher: PhotoCollectionFetching {
    private let flickrPhotosService: FlickrPhotosFetching
    private let collectionDataFetcher: FlickrCollectionDataFetching

    init(flickrPhotosService: FlickrPhotosFetching, collectionDataFetcher: FlickrCollectionDataFetching) {
        self.flickrPhotosService = flickrPhotosService
        self.collectionDataFetcher = collectionDataFetcher
    }

    func fetchPhotos(startingFrom position: Int,
                     fetchAtMost maxFetchCount: Int,
                     withSize size: PhotoParameters.Size,
                     completion: @escaping Completion) {
        let page = position / maxFetchCount + 1
        let metadata = PhotoParameters.Metadata.allCases

        flickrPhotosService.getRecent(
                page: page,
                photosPerPage: maxFetchCount,
                includeMetadata: metadata,
                completion: transformFetchResult(withSize: size, completion)
        )
    }

    private func transformFetchResult(withSize size: PhotoParameters.Size, _ completion: @escaping Completion) -> FlickrPhotosService.Completion {
        { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case let .success(photos):
                self.transformValidPhotos(photos, withSize: size) { validPhotos in
                    completion(.success(validPhotos))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func transformValidPhotos(_ photos: [FlickrPhoto],
                                      withSize size: PhotoParameters.Size,
                                      _ completion: @escaping ([Photo]) -> Void) {
        collectionDataFetcher.fetchData(photos: photos, withSize: size) { photosImageData in
            let transformedPhotos = photos.map { photo -> Photo? in
                guard let metadata = extractMetadata(from: photo) else {
                    return nil
                }

                guard let imageData = photosImageData[photo.id] else {
                    return nil
                }

                let fullSizeImageURL = FlickrPhotoURLResolver.resolveUrl(for: photo, withSize: .large)

                return Photo(
                        id: photo.id,
                        imageData: imageData,
                        fullSizeImageURL: fullSizeImageURL,
                        metadata: metadata
                )
            }

            completion(transformedPhotos.compactMap { $0 })   
        }
    }
}

private func extractMetadata(from photo: FlickrPhoto) -> Photo.Metadata? {
    let dateTakenFormatter = DateFormatter()
    dateTakenFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"

    guard let views = photo.views.toInt() else {
        return nil
    }

    guard let dateTaken = photo.datetaken.toDate(formatter: dateTakenFormatter) else {
        return nil
    }

    return Photo.Metadata(
            views: views,
            tags: photo.tags.components(separatedBy: " "),
            ownerName: photo.ownername,
            dateTaken: dateTaken
    )
}