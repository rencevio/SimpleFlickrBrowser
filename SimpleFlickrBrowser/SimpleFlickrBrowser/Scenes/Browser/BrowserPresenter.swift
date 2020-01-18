//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol BrowserPresenting: AnyObject {
    func present(photos: Photos.Response)
}

final class BrowserPresenter: BrowserPresenting {
    weak var view: BrowserDisplaying?

    private var currentSearchQuery: String = ""

    func present(photos: Photos.Response) {
        let viewModel = Photos.ViewModel(photos: photos.photos)

        if currentSearchQuery != photos.searchCriteria {
            currentSearchQuery = photos.searchCriteria
            view?.displayNew(photos: viewModel)
        } else {
            view?.displayMore(photos: viewModel)
        }
    }
}
