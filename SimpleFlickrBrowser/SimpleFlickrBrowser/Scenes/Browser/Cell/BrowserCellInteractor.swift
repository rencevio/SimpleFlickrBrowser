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

    init(presenter: BrowserCellPresenting, photoDataProvider: PhotoDataProviding) {
        self.presenter = presenter
        self.photoDataProvider = photoDataProvider
    }

    func fetch(image: PhotoImage.Request) {
        photoDataProvider.getPhotoData(from: image.url) { [weak presenter] result in
            DispatchQueue.main.async { [weak presenter] in
                switch result {
                case .success(let data):
                    presenter?.present(image: PhotoImage.Response(data: data))
                case .failure:
                    presenter?.presentError()
                }
            }
        }
    }
}