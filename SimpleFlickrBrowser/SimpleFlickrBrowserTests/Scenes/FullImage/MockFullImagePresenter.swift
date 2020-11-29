//
// Created by Maxim Berezhnoy on 29/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import Foundation

final class MockFullImagePresenter: FullImagePresenting {
    var presentImageCalls = [FullImageModels.Image.Response]()
    var presentErrorCalls = 0

    func present(image: FullImageModels.Image.Response) {
        presentImageCalls.append(image)
    }
    
    func presentError() {
        presentErrorCalls += 1
    }
}
