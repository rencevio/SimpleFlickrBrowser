//
// Created by Maxim Berezhnoy on 22/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol FeedDisplaying: AnyObject {
    func displayNew(photos: FeedModels.Photos.ViewModel)
    func displayMore(photos: FeedModels.Photos.ViewModel)
}

private struct LayoutConstants {
    static let photoSize = PhotoParameters.Size.medium
    static let itemSpacing: CGFloat = 30
}

final class FeedViewController: UIViewController {
    private let photosPerFetchRequest = 4
    private let metadataToFetch: [PhotoParameters.Metadata] = [
        .views,
        .dateTaken,
        .tags,
        .ownerName
    ]

    private let interactor: FeedInteracting
    private let dataSource: FeedDataSourcing
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        
        view.alwaysBounceVertical = true
        view.backgroundColor = Style.ScreenBackground.color
        
        view.tableFooterView = UIView()
        view.separatorStyle = .none
        view.sectionHeaderHeight = LayoutConstants.itemSpacing
        
        view.allowsSelection = false
        
        return view
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl(frame: .zero)

        return control
    }()

    init(interactor: FeedInteracting, dataSource: FeedDataSourcing) {
        self.interactor = interactor
        self.dataSource = dataSource

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupRefreshControl()

        requestNewPhotos()
    }

    // MARK: - View Setup

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        tableView.delegate = self

        dataSource.register(for: tableView)
    }
    
    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl

        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    // MARK: - Data Requesting
    
    private func requestNewPhotos() {
        interactor.fetch(
                photos: FeedModels.Photos.Request(
                        startFromPosition: dataSource.photoCount,
                        fetchAtMost: photosPerFetchRequest,
                        size: LayoutConstants.photoSize,
                        metadata: metadataToFetch
                )
        )   
    }

    func requestMorePhotos() {
        interactor.fetch(
                photos: FeedModels.Photos.Request(
                        startFromPosition: dataSource.photoCount,
                        fetchAtMost: photosPerFetchRequest,
                        size: LayoutConstants.photoSize,
                        metadata: metadataToFetch
                )
        )
    }
}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { 
        UIView()
    }

    public func tableView(_ tableView: UITableView, 
                          willDisplay cell: UITableViewCell, 
                          forRowAt indexPath: IndexPath) {
        let itemToDisplay = indexPath.section

        let loadedPhotosCount = dataSource.photoCount

        if itemToDisplay == loadedPhotosCount {
            requestMorePhotos()
        }
    }
}

// MARK: - FeedDisplaying

extension FeedViewController: FeedDisplaying {
    func displayNew(photos: FeedModels.Photos.ViewModel) {
        dataSource.set(photos: photos.photos)

        refreshControl.endRefreshing()

        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }

    func displayMore(photos: FeedModels.Photos.ViewModel) {
        let currentPhotoCount = dataSource.photoCount

        dataSource.add(photos: photos.photos)

        tableView.insertSections(IndexSet(integersIn: currentPhotoCount..<currentPhotoCount + photos.photos.count), with: .none)
    }
}

// MARK: - Refresh control

extension FeedViewController {
    @objc func handleRefreshControl() {
        requestNewPhotos()
    }
}
