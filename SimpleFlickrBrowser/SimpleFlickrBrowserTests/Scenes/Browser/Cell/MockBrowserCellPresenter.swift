//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

@testable import SimpleFlickrBrowser

import Foundation

final class MockBrowserCellPresenter: BrowserCellPresenting {
    var presentCalls = [PhotoImage.Response]()
    var presentErrorCalls = 0

    func present(image: PhotoImage.Response) {
        presentCalls.append(image)
    }

    func presentError() {
        presentErrorCalls += 1
    }
}