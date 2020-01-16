//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

protocol BrowserInteracting {
    func fetch(photos: Photos.Request)
}

final class BrowserInteractor: BrowserInteracting {
    private let presenter: BrowserPresenting

    init(presenter: BrowserPresenting) {
        self.presenter = presenter
    }

    func fetch(photos: Photos.Request) {
        DispatchQueue.main.async { [weak presenter] in
            let placeholderUrl = URL(string: "https://i.pinimg.com/236x/16/9f/72/169f72e28f26290e54a1f831b6c4714e.jpg")!
            presenter?.present(
                    photos: Photos.Response(
                            photos: [
                                Photo(id: "1", image: placeholderUrl),
                                Photo(id: "2", image: placeholderUrl),
                                Photo(id: "3", image: placeholderUrl),
                                Photo(id: "4", image: placeholderUrl),
                                Photo(id: "5", image: placeholderUrl)
                            ]
                    )
            )
        }
    }
}