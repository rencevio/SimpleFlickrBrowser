//
// Created by Maxim Berezhnoy on 29/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol FullImagePresenting {
    func present(image: FullImageModels.Image.Response)
    func presentError()
}

final class FullImagePresenter: FullImagePresenting {
    weak var view: FullImageDisplaying?
    
    func present(image: FullImageModels.Image.Response) {
        view?.display(image: FullImageModels.Image.ViewModel(image: image.image))
    }
    
    func presentError() {
        view?.displayError()
    }
}