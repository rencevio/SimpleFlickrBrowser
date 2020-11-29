//
// Created by Maxim Berezhnoy on 27/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol FeedRouting: Routing {
    func displayFullImage(withInfo info: Photo)
}

final class FeedRouter: FeedRouting {
    var sourceVC: UIViewController?
    
    private let fullImageFactory: FullImageCreating

    init(fullImageFactory: FullImageCreating) {
        self.fullImageFactory = fullImageFactory
    }

    func displayFullImage(withInfo info: Photo) {
        guard let sourceVC = sourceVC else {
            return
        }
        
        let fullImageViewController = fullImageFactory.createViewController()
        
        sourceVC.present(fullImageViewController, animated: true)
    }
}