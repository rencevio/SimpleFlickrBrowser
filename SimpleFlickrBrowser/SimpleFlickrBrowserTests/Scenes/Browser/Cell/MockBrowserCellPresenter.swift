//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import Foundation

final class MockBrowserCellPresenter: BrowserCellPresenting {
    var presentImageCalls = [BrowserCellModels.PhotoImage.Response]()
    var presentErrorCalls = 0
    var presentLoadingCalls = 0

    func present(image: BrowserCellModels.PhotoImage.Response) {
        presentImageCalls.append(image)
    }

    func presentLoading() {
        presentLoadingCalls += 1
    }

    func presentError() {
        presentErrorCalls += 1
    }
}
