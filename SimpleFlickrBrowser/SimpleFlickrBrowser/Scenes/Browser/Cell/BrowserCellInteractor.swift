//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

protocol BrowserCellInteracting {
    func fetch(image: PhotoImage.Request)
}

final class BrowserCellInteractor: BrowserCellInteracting {
    private let presenter: BrowserCellPresenting
    private let photoDataProvider: PhotoDataProviding

    private var currentPhotoId: Photo.ID?

    init(presenter: BrowserCellPresenting, photoDataProvider: PhotoDataProviding) {
        self.presenter = presenter
        self.photoDataProvider = photoDataProvider
    }

    func fetch(image: PhotoImage.Request) {
        presenter.presentLoading()

        currentPhotoId = image.photoID

        photoDataProvider.getPhotoData(from: image.url) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                // Do not send a response if the ID has changed meanwhile.
                // Another option would be to make requests to provider cancelable
                if let currentPhotoId = self.currentPhotoId, currentPhotoId == image.photoID {
                    switch result {
                    case let .success(data):
                        self.presenter.present(image: PhotoImage.Response(data: data))
                    case .failure:
                        self.presenter.presentError()
                    }
                }
            }
        }
    }
}
