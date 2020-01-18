//
// Created by Maxim Berezhnoy on 15/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol BrowserDisplaying: class {
    func display(photos: Photos.ViewModel)
}

private struct LayoutConstants {
    static let itemsPerRow = 3

    static let padding: CGFloat = 10.0
    static let interitemSpacing: CGFloat = 10
    static let lineSpacing: CGFloat = 10

    static let heightRatio: CGFloat = 1.0
}

final class BrowserViewController: UIViewController {
    private let photosPerFetchRequest = LayoutConstants.itemsPerRow * 15

    private let interactor: BrowserInteracting
    private let dataSource: BrowserDataSourcing

    private var currentSearchQuery = ""

    private lazy var searchController: UISearchController = {
        let controller = UISearchController()

        controller.obscuresBackgroundDuringPresentation = false
        controller.definesPresentationContext = true

        return controller
    }()

    private lazy var collectionFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()

        layout.sectionInset = UIEdgeInsets(
                top: LayoutConstants.padding,
                left: LayoutConstants.padding,
                bottom: LayoutConstants.padding,
                right: LayoutConstants.padding
        )

        layout.minimumInteritemSpacing = LayoutConstants.interitemSpacing
        layout.minimumLineSpacing = LayoutConstants.lineSpacing

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
        setupSearchController()

        interactor.fetch(photos: Photos.Request(startFromPosition: 0, fetchAtMost: photosPerFetchRequest, searchCriteria: nil))
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        collectionView.delegate = self

        dataSource.register(for: collectionView)
    }

    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.enablesReturnKeyAutomatically = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: - BrowserDisplaying
extension BrowserViewController: BrowserDisplaying {
    func display(photos: Photos.ViewModel) {
        dataSource.set(photos: photos.photos)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BrowserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = self.collectionView.bounds.width - LayoutConstants.padding * 2

        let totalInteritemSpacing = CGFloat(LayoutConstants.itemsPerRow - 1) * LayoutConstants.interitemSpacing

        let itemWidth = ((viewWidth - totalInteritemSpacing) / CGFloat(LayoutConstants.itemsPerRow)).rounded(.down)

        return CGSize(width: itemWidth, height: itemWidth * LayoutConstants.heightRatio)
    }
}

// MARK: - UISearchBarDelegate
extension BrowserViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }

        if query != currentSearchQuery {
            currentSearchQuery = query
            interactor.fetch(
                    photos: Photos.Request(
                            startFromPosition: 0,
                            fetchAtMost: photosPerFetchRequest,
                            searchCriteria: query
                    )
            )
        }
    }
}
