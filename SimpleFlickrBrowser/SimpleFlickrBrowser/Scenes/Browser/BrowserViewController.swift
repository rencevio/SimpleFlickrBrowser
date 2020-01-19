//
// Created by Maxim Berezhnoy on 15/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol BrowserDisplaying: AnyObject {
    func displayNew(photos: Photos.ViewModel)
    func displayMore(photos: Photos.ViewModel)
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

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl(frame: .zero)

        return control
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
        setupRefreshControl()

        requestNewPhotos()
    }

    // MARK: - View Setup

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

    private func setupRefreshControl() {
        collectionView.refreshControl = refreshControl

        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    // MARK: - Data requesting

    func requestMorePhotos() {
        interactor.fetch(
            photos: Photos.Request(
                startFromPosition: dataSource.photoCount,
                fetchAtMost: photosPerFetchRequest,
                searchCriteria: searchController.searchBar.text ?? ""
            )
        )
    }

    func requestNewPhotos() {
        interactor.fetch(
            photos: Photos.Request(
                startFromPosition: 0,
                fetchAtMost: photosPerFetchRequest,
                searchCriteria: searchController.searchBar.text ?? ""
            )
        )
    }
}

// MARK: - BrowserDisplaying

extension BrowserViewController: BrowserDisplaying {
    func displayNew(photos: Photos.ViewModel) {
        dataSource.set(photos: photos.photos)

        refreshControl.endRefreshing()

        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }

    func displayMore(photos: Photos.ViewModel) {
        let currentPhotoCount = dataSource.photoCount

        dataSource.add(photos: photos.photos)

        collectionView.insertItems(at: (0 ..< photos.photos.count).map { IndexPath(item: $0 + currentPhotoCount, section: 0) })
    }
}

// MARK: - UICollectionViewDelegate

extension BrowserViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let itemToDisplay = indexPath.item

        let loadedPhotosCount = dataSource.photoCount

        if itemToDisplay == loadedPhotosCount - LayoutConstants.itemsPerRow * 4 {
            requestMorePhotos()
        }
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
        requestNewPhotos()
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        requestNewPhotos()
    }
}

// MARK: - Refresh control

extension BrowserViewController {
    @objc func handleRefreshControl() {
        requestNewPhotos()
    }
}
