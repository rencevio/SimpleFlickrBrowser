//
// Created by Maxim Berezhnoy on 29/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol FullImageCreating {
    func createViewController() -> FullImageViewController
}

final class FullImageFactory: FullImageCreating {
    func createViewController() -> FullImageViewController {
        FullImageViewController()
    }
}