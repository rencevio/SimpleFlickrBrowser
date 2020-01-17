//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol BrowserCellDisplaying: class {
    func display(image: PhotoImage.ViewModel)
}

final class BrowserViewCell: UICollectionViewCell {
    static let identifier = "\(BrowserViewCell.self)"

    private var interactor: BrowserCellInteracting?

    private var photo: Photo?

    lazy var placeholderLabel: UILabel = {
        let label = UILabel()

        label.text = photo?.id ?? "unknown"

        label.textAlignment = .center

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0

        addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        placeholderLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        placeholderLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - BrowserCellDisplaying
extension BrowserViewCell: BrowserCellDisplaying {
    func display(image: PhotoImage.ViewModel) {
        
    }
}

// MARK: - ConfigurableBrowserCell
extension BrowserViewCell: ConfigurableBrowserCell {
    func configure(interactor: BrowserCellInteracting, photo: Photo) {
        self.interactor = interactor
        self.photo = photo
        
        interactor.fetch(image: PhotoImage.Request(url: photo.image))
    }
}