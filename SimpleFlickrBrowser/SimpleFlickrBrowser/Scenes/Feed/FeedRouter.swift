//
// Created by Maxim Berezhnoy on 27/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol FeedRouting: Routing {
    func displayFullImage(withInfoFrom photo: Photo)
}

final class FeedRouter: FeedRouting {
    var sourceVC: UIViewController?

    private let fullImageFactory: FullImageCreating

    init(fullImageFactory: FullImageCreating) {
        self.fullImageFactory = fullImageFactory
    }

    func displayFullImage(withInfoFrom photo: Photo) {
        guard let sourceVC = sourceVC else {
            return
        }

        let fullImageViewController = fullImageFactory.createViewController(withInfoFrom: photo)
        
        fullImageViewController.modalPresentationStyle = .fullScreen
        fullImageViewController.modalTransitionStyle = .crossDissolve
        sourceVC.present(fullImageViewController, animated: true)
    }
}
