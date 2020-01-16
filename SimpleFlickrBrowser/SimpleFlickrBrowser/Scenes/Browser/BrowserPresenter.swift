//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol BrowserPresenting: class {
    func present(photos: Photos.Response)
}

final class BrowserPresenter: BrowserPresenting {
    weak var view: BrowserDisplaying?

    func present(photos: Photos.Response) {
        view?.display(photos: Photos.ViewModel(photos: photos.photos))
    }
}