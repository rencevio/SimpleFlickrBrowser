//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol BrowserCellPresenting: AnyObject {
    func present(image: BrowserCellModels.PhotoImage.Response)
    func presentLoading()
    func presentError()
}

final class BrowserCellPresenter: BrowserCellPresenting {
    weak var view: BrowserCellDisplaying?

    func present(image: BrowserCellModels.PhotoImage.Response) {
        guard let view = view,
            let image = UIImage(data: image.data)
        else { return }

        view.display(image: BrowserCellModels.PhotoImage.ViewModel(image: image))
    }

    func presentLoading() {
        view?.displayLoading()
    }

    func presentError() {
        view?.displayLoading()
    }
}
