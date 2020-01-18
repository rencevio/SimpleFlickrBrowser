//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol BrowserCellDisplaying: class {
    func display(image: PhotoImage.ViewModel)
    func displayLoading()
}

final class BrowserViewCell: UICollectionViewCell {
    private enum ViewState {
        case loading
        case image(UIImage)
    }

    static let identifier = "\(BrowserViewCell.self)"

    private var interactor: BrowserCellInteracting?

    lazy var imageView: UIImageView = {
        let view = UIImageView()

        view.contentMode = .scaleAspectFit

        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7

        return view
    }()

    lazy var placeholderView: UIView = {
        let view = UIView()

        let label = UILabel(frame: .zero)

        label.text = "Placeholder"
        label.textAlignment = .center
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupImageView()
        setupPlaceholderView()

        set(state: .loading)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageView() {
        addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }

    private func setupPlaceholderView() {
        addSubview(placeholderView)

        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        placeholderView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        placeholderView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        placeholderView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }

    private func set(state: ViewState) {
        switch state {
        case .loading:
            placeholderView.isHidden = false
            imageView.isHidden = true

        case .image(let image):
            imageView.isHidden = false
            placeholderView.isHidden = true

            imageView.image = image
        }
    }
}

// MARK: - BrowserCellDisplaying
extension BrowserViewCell: BrowserCellDisplaying {
    func display(image: PhotoImage.ViewModel) {
        set(state: .image(image.image))
    }

    func displayLoading() {
        set(state: .loading)
    }
}

// MARK: - ConfigurableBrowserCell
extension BrowserViewCell: ConfigurableBrowserCell {
    func configure(interactor: BrowserCellInteracting, photo: Photo) {
        self.interactor = interactor

        interactor.fetch(image: PhotoImage.Request(photoID: photo.id, url: photo.image))
    }
}