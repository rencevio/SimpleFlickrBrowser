//
// Created by Maxim Berezhnoy on 22/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol FeedDisplaying: AnyObject {
    func displayNew(photos: FeedModels.Photos.ViewModel)
    func displayMore(photos: FeedModels.Photos.ViewModel)
}

final class FeedViewController: UIViewController {
    private let photoSize = PhotoParameters.Size.medium

    private let interactor: FeedInteracting
    private let dataSource: FeedDataSourcing
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        
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
        
    }
    
    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl

        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    // MARK: - Data Requesting
    
    private func requestNewPhotos() {
        
    }
}

// MARK: - FeedDisplaying

extension FeedViewController: FeedDisplaying {
    func displayNew(photos: FeedModels.Photos.ViewModel) {
        refreshControl.endRefreshing()
    }

    func displayMore(photos: FeedModels.Photos.ViewModel) {}
}

// MARK: - Refresh control

extension FeedViewController {
    @objc func handleRefreshControl() {
        requestNewPhotos()
    }
}
