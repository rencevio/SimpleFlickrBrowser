//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

final class RootDependencies {
    func createBrowserViewController() -> BrowserViewController {
        let browserFactory = BrowserFactory()
        
        return browserFactory.createBrowserViewController()
    }
}