//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

class MockFeedDisplaying: FeedDisplaying {
    var displayNewPhotosCalls = [FeedModels.Photos.ViewModel]()
    var displayMorePhotosCalls = [FeedModels.Photos.ViewModel]()

    func displayNew(photos: FeedModels.Photos.ViewModel) {
        displayNewPhotosCalls.append(photos)
    }

    func displayMore(photos: FeedModels.Photos.ViewModel) {
        displayMorePhotosCalls.append(photos)
    }
}
