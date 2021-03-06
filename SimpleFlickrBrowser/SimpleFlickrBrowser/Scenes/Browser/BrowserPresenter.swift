//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol BrowserPresenting: AnyObject {
    func present(photos: BrowserModels.Photos.Response)
}

final class BrowserPresenter: BrowserPresenting {
    weak var view: BrowserDisplaying?

    func present(photos: BrowserModels.Photos.Response) {
        let viewModel = BrowserModels.Photos.ViewModel(photos: photos.photos)

        if photos.startingPosition == 0 {
            view?.displayNew(photos: viewModel)
        } else {
            view?.displayMore(photos: viewModel)
        }
    }
}
