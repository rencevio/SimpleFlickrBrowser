//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol BrowserCellDisplaying: class {
    func display(image: PhotoImage.ViewModel)
}

final class BrowserCellView: UICollectionViewCell {
    let identifier = "\(BrowserCellView.self)Identifier"

    var photo: Photo? {
        didSet {
            guard let photo = photo else { return }
            interactor.fetch(image: PhotoImage.Request(url: photo.image))
        }
    }

    private let interactor: BrowserCellInteracting

    init(interactor: BrowserCellInteracting) {
        self.interactor = interactor

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - BrowserCellDisplaying
extension BrowserCellView: BrowserCellDisplaying {
    func display(image: PhotoImage.ViewModel) {

    }
}