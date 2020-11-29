//
// Created by Maxim Berezhnoy on 29/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol FullImageCreating {
    func createViewController(withInfoFrom photo: Photo) -> FullImageViewController
}

final class FullImageFactory: FullImageCreating {
    private let photoDataProvider: PhotoDataProviding

    init(photoDataProvider: PhotoDataProviding) {
        self.photoDataProvider = photoDataProvider
    }

    func createViewController(withInfoFrom photo: Photo) -> FullImageViewController {
        let presenter = FullImagePresenter()
        let interactor = FullImageInteractor(presenter: presenter, photoDataProvider: photoDataProvider)

        let viewController = FullImageViewController(photo: photo, interactor: interactor)

        presenter.view = viewController

        return viewController
    }
}