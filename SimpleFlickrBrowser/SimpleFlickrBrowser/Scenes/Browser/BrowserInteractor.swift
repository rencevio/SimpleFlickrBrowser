//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

protocol BrowserInteracting {
    func fetchPhotos()
}

final class BrowserInteractor: BrowserInteracting {
    private let presenter: BrowserPresenting

    init(presenter: BrowserPresenting) {
        self.presenter = presenter
    }

    func fetchPhotos() {
        DispatchQueue.main.async { [weak presenter] in
            presenter?.present(photos: [Photo(id: "1"), Photo(id: "2"), Photo(id: "3"), Photo(id: "4"), Photo(id: "5")])
        }
    }
}