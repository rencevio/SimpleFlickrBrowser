//
// Created by Maxim Berezhnoy on 25/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol FeedCellPresenting: AnyObject {
    func present(image: FeedCellModels.PhotoImage.Response)
    func presentLoading()
    func presentError()
}

final class FeedCellPresenter: FeedCellPresenting {
    weak var view: FeedCellDisplaying?

    func present(image: FeedCellModels.PhotoImage.Response) {
        guard let view = view,
              let image = UIImage(data: image.data)
                else { return }

        view.display(image: FeedCellModels.PhotoImage.ViewModel(image: image))
    }

    func presentLoading() {
        view?.displayLoading()
    }

    func presentError() {
        view?.displayLoading()
    }
}
