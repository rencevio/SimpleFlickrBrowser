//
// Created by Maxim Berezhnoy on 25/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

protocol FeedCellInteracting {
    func fetch(image: FeedCellModels.PhotoImage.Request)
}

final class FeedCellInteractor: FeedCellInteracting {
    private let presenter: FeedCellPresenting
    private let photoDataProvider: PhotoDataProviding

    private var currentPhotoId: Photo.ID?

    init(presenter: FeedCellPresenting, photoDataProvider: PhotoDataProviding) {
        self.presenter = presenter
        self.photoDataProvider = photoDataProvider
    }

    func fetch(image: FeedCellModels.PhotoImage.Request) {
        presenter.presentLoading()

        currentPhotoId = image.photoID

        photoDataProvider.getPhotoData(from: image.url) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                // Do not send a response if the ID has changed in the meantime.
                // Another option would be to make requests to provider cancelable
                if let currentPhotoId = self.currentPhotoId, currentPhotoId == image.photoID {
                    switch result {
                    case let .success(data):
                        self.presenter.present(image: FeedCellModels.PhotoImage.Response(data: data))
                    case .failure:
                        self.presenter.presentError()
                    }
                }
            }
        }
    }
}