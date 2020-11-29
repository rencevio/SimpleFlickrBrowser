//
// Created by Maxim Berezhnoy on 29/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

protocol FullImageInteracting {
    func fetch(image: FullImageModels.Image.Request)
}

final class FullImageInteractor: FullImageInteracting {
    private let presenter: FullImagePresenting
    private let photoDataProvider: PhotoDataProviding

    init(presenter: FullImagePresenting, photoDataProvider: PhotoDataProviding) {
        self.presenter = presenter
        self.photoDataProvider = photoDataProvider
    }

    func fetch(image: FullImageModels.Image.Request) {
        photoDataProvider.getPhotoData(from: image.url) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }

                switch result {
                case let .success(data):
                    self.presenter.present(image: FullImageModels.Image.Response(image: data))
                case .failure(_):
                    self.presenter.presentError()
                }
            }
        }
    }
}