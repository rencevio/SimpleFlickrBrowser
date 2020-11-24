//
// Created by Maxim Berezhnoy on 22/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

protocol FeedInteracting {
    func fetch(photos request: FeedModels.Photos.Request)
}

final class FeedInteractor: FeedInteracting {
    private let presenter: FeedPresenting
    private let photoCollectionFetcher: PhotoCollectionFetching

    private var currentRequest: FeedModels.Photos.Request?

    init(presenter: FeedPresenting, photoCollectionFetcher: PhotoCollectionFetching) {
        self.presenter = presenter
        self.photoCollectionFetcher = photoCollectionFetcher
    }

    func fetch(photos request: FeedModels.Photos.Request) {
        if currentRequest == request {
            return
        }

        currentRequest = request

        photoCollectionFetcher.fetchPhotos(
                startingFrom: request.startFromPosition,
                fetchAtMost: request.fetchAtMost,
                matching: request.searchCriteria,
                withSize: request.size,
                includeMetadata: []
        ) { result in
            switch result {
            case let .success(photos):
                DispatchQueue.main.async { [weak self, request] in
                    guard let self = self else { return }

                    if self.currentRequest == request {
                        self.currentRequest = nil
                    }

                    let response = FeedModels.Photos.Response(startingPosition: request.startFromPosition, photos: photos)

                    self.presenter.present(photos: response)
                }
            case let .failure(error):
                print("Error while retrieving photos (request: \(request)): \(error)")
            }
        }
    }
}
