//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import Foundation

final class MockBrowserPresenter: BrowserPresenting {
    var presentPhotosCalls = [BrowserModels.Photos.Response]()

    func present(photos: BrowserModels.Photos.Response) {
        presentPhotosCalls.append(photos)
    }
}
