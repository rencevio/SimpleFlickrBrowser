//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

class MockBrowserDisplaying: BrowserDisplaying {
    var displayNewPhotosCalls = [BrowserModels.Photos.ViewModel]()
    var displayMorePhotosCalls = [BrowserModels.Photos.ViewModel]()

    func displayNew(photos: BrowserModels.Photos.ViewModel) {
        displayNewPhotosCalls.append(photos)
    }

    func displayMore(photos: BrowserModels.Photos.ViewModel) {
        displayMorePhotosCalls.append(photos)
    }
}
