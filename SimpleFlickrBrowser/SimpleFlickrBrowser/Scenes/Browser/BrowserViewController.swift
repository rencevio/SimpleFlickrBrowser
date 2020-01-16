//
// Created by Maxim Berezhnoy on 15/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol BrowserDisplaying: class {
    func display(photos: [Photo])
}

final class BrowserViewController: UIViewController {
    private let interactor: BrowserInteracting
    private let dataSource: BrowserDataSourcing

    private lazy var collectionFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()

        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionFlowLayout)

        view.alwaysBounceVertical = true
        view.backgroundColor = Style.ScreenBackground.color

        return view
    }()

    init(interactor: BrowserInteracting, dataSource: BrowserDataSourcing) {
        self.interactor = interactor
        self.dataSource = dataSource

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()

        interactor.fetchPhotos()
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        dataSource.register(for: collectionView)
    }
}

// MARK: - BrowserDisplaying
extension BrowserViewController: BrowserDisplaying {
    func display(photos: [Photo]) {
        dataSource.set(photos: photos)
        collectionView.reloadData()
    }
}