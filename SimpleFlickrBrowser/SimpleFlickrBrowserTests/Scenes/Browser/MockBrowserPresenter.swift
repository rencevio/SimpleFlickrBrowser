//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import Foundation

final class MockBrowserPresenter: BrowserPresenting {
    var presentPhotosCalls = [Photos.Response]()

    func present(photos: Photos.Response) {
        presentPhotosCalls.append(photos)
    }
}
