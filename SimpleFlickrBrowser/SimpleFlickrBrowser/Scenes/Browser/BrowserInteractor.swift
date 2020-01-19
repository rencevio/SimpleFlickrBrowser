//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

protocol BrowserInteracting {
    func fetch(photos request: Photos.Request)
}

final class BrowserInteractor: BrowserInteracting {
    private let presenter: BrowserPresenting
    private let photoCollectionFetcher: PhotoCollectionFetching

    private var currentRequest: Photos.Request?

    init(presenter: BrowserPresenting, photoCollectionFetcher: PhotoCollectionFetching) {
        self.presenter = presenter
        self.photoCollectionFetcher = photoCollectionFetcher
    }

    func fetch(photos request: Photos.Request) {
        if currentRequest == request {
            return
        }

        currentRequest = request

        photoCollectionFetcher.fetchPhotos(
            startingFrom: request.startFromPosition,
            fetchAtMost: request.fetchAtMost,
            matching: request.searchCriteria
        ) { result in
            switch result {
            case let .success(photos):
                DispatchQueue.main.async { [weak self, request] in
                    guard let self = self else { return }

                    if self.currentRequest == request {
                        self.currentRequest = nil
                    }

                    let response = Photos.Response(startingPosition: request.startFromPosition, photos: photos)

                    self.presenter.present(photos: response)
                }
            case let .failure(error):
                print("Error while retrieving photos (request: \(request)): \(error)")
            }
        }
    }
}
