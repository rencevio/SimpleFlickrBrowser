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

    init(presenter: BrowserPresenting, photoCollectionFetcher: PhotoCollectionFetching) {
        self.presenter = presenter
        self.photoCollectionFetcher = photoCollectionFetcher
    }

    func fetch(photos request: Photos.Request) {
        photoCollectionFetcher.fetchPhotos(
                startingFrom: request.startFromPosition,
                fetchAtMost: request.fetchAtMost,
                matching: request.searchCriteria) { [weak presenter] result in
            switch result {
            case .success(let photos):
                DispatchQueue.main.async { [weak presenter] in
                    presenter?.present(photos: Photos.Response(photos: photos))
                }
            case .failure(let error):
                print("Error while retrieving photos (request: \(request)): \(error)")
                break
            }
        }
    }
}