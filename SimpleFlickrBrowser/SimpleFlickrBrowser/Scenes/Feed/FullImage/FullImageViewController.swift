//
// Created by Maxim Berezhnoy on 27/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol FullImageDisplaying: AnyObject {
    func display(image: FullImageModels.Image.ViewModel)
    func displayError()
}

final class FullImageViewController: UIViewController {
    private let interactor: FullImageInteracting
    private let photo: Photo
            
    private enum State {
        case loading
        case image(image: UIImage)
        case error
    }

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit

        return view
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()

        indicator.hidesWhenStopped = true
        indicator.color = Style.FullImage.LoadingIndicator.color

        return indicator
    }()

    init(photo: Photo, interactor: FullImageInteracting) {
        self.photo = photo
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() { 
        super.viewDidLoad()
        
        view.backgroundColor = Style.FullImage.Background.color
        
        setupImageView()
        setupLoadingIndicator()
        
        set(state: .loading)
        interactor.fetch(image: FullImageModels.Image.Request(url: photo.fullSizeImageURL))
    }

    // MARK: - UI Setup
    
    private func setupImageView() {
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }

    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func set(state: State) {
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
            imageView.isHidden = true
        case let .image(image):
            loadingIndicator.stopAnimating()
            imageView.isHidden = false
            imageView.image = image
        case .error:
            loadingIndicator.stopAnimating()
            imageView.isHidden = true
        }
    }
}

// MARK: - FullImageDisplaying

extension FullImageViewController: FullImageDisplaying {
    func display(image: FullImageModels.Image.ViewModel) {
        if let image = UIImage(data: image.image) {
            set(state: .image(image: image))
        } else {
            set(state: .error)
        }
    }

    func displayError() {
        set(state: .error)
    }
}