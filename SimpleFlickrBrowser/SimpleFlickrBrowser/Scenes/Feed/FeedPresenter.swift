//
// Created by Maxim Berezhnoy on 22/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol FeedPresenting: AnyObject {
    func present(photos: FeedModels.Photos.Response)
}

final class FeedPresenter: FeedPresenting {
    weak var view: FeedDisplaying?

    func present(photos: FeedModels.Photos.Response) {
        let viewModel = FeedModels.Photos.ViewModel(photos: photos.photos)

        if photos.startingPosition == 0 {
            view?.displayNew(photos: viewModel)
        } else {
            view?.displayMore(photos: viewModel)
        }
    }
}
