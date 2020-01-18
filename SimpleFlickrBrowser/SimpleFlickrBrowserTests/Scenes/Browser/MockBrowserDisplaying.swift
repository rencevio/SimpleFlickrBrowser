//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

class MockBrowserDisplaying: BrowserDisplaying {
    var displayNewPhotosCalls = [Photos.ViewModel]()
    var displayMorePhotosCalls = [Photos.ViewModel]()
    
    func displayNew(photos: Photos.ViewModel) {
        displayNewPhotosCalls.append(photos)
    }

    func displayMore(photos: Photos.ViewModel) {
        displayMorePhotosCalls.append(photos)
    }
}