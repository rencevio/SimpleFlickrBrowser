//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import Foundation

final class MockFeedPresenter: FeedPresenting {
    var presentPhotosCalls = [FeedModels.Photos.Response]()

    func present(photos: FeedModels.Photos.Response) {
        presentPhotosCalls.append(photos)
    }
}
