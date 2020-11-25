//
// Created by Maxim Berezhnoy on 25/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

protocol FeedCellDisplaying: AnyObject {
    func display(image: FeedCellModels.PhotoImage.ViewModel)
    func displayLoading()
}

private struct LayoutConstants {
    static let ownerNameFontSize: CGFloat = 12
    static let tagsFontSize: CGFloat = 11
    static let viewsFontSize: CGFloat = 12
    static let dateTakenFontSize: CGFloat = 12

    static let sideMarginRatio: CGFloat = 0.02
    static let tagsSideMarginRatio: CGFloat = 0.04
    static let topBottomMarginRatio: CGFloat = 0.2
    
    static let dateTakenFormat = "MMM dd, yyyy"
}

final class FeedViewCell: UITableViewCell {
    private enum ImageViewState {
        case loading
        case image(UIImage)
    }

    static let identifier = "\(FeedViewCell.self)"

    private var interactor: FeedCellInteracting?

    private var heightConstraint: NSLayoutConstraint?

    // MARK: - Subviews
    lazy var cellImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit

        return view
    }()

    lazy var ownerNameView: UILabel = {
        let view = UILabel()

        view.font = UIFont.systemFont(ofSize: LayoutConstants.ownerNameFontSize)

        return view
    }()

    lazy var viewsView: ViewsLabel = {
        let view = ViewsLabel()

        view.font = UIFont.systemFont(ofSize: LayoutConstants.viewsFontSize)

        return view
    }()

    lazy var tagsView: TagsLabel = {
        let view = TagsLabel()

        view.font = UIFont.boldSystemFont(ofSize: LayoutConstants.tagsFontSize)
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0

        return view
    }()

    lazy var dateTakenView: DateLabel = {
        let view = DateLabel(dateFormat: LayoutConstants.dateTakenFormat)

        view.font = UIFont.systemFont(ofSize: LayoutConstants.dateTakenFontSize)

        return view
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupImageView()
        setupOwnerNameView()
        setupViewsView()
        setupTagsView()
        setupDateTakenView()

        set(imageState: .loading)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var widthConstraint: NSLayoutConstraint = {
        let constraint = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        constraint.isActive = true
        return constraint
    }()

    override func systemLayoutSizeFitting(_ targetSize: CGSize, 
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, 
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
        widthConstraint.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }

    // MARK: - View Setup
    private func setupImageView() {
        contentView.addSubview(cellImageView)

        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }

    private func setupOwnerNameView() {
        contentView.addSubview(ownerNameView)

        ownerNameView.translatesAutoresizingMaskIntoConstraints = false
        ownerNameView.topAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: frame.height * LayoutConstants.topBottomMarginRatio).isActive = true
        ownerNameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: frame.width * LayoutConstants.sideMarginRatio).isActive = true
    }

    private func setupViewsView() {
        contentView.addSubview(viewsView)

        viewsView.translatesAutoresizingMaskIntoConstraints = false
        viewsView.topAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: frame.height * LayoutConstants.topBottomMarginRatio).isActive = true
        viewsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1 * frame.width * LayoutConstants.sideMarginRatio).isActive = true
    }

    private func setupTagsView() {
        contentView.addSubview(tagsView)

        tagsView.translatesAutoresizingMaskIntoConstraints = false
        tagsView.topAnchor.constraint(equalTo: ownerNameView.bottomAnchor, constant: frame.height * LayoutConstants.topBottomMarginRatio).isActive = true
        tagsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: frame.width * LayoutConstants.tagsSideMarginRatio).isActive = true
        tagsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1 * frame.width * LayoutConstants.tagsSideMarginRatio).isActive = true
    }

    private func setupDateTakenView() {
        contentView.addSubview(dateTakenView)

        dateTakenView.translatesAutoresizingMaskIntoConstraints = false
        dateTakenView.topAnchor.constraint(equalTo: tagsView.bottomAnchor, constant: frame.height * LayoutConstants.topBottomMarginRatio).isActive = true
        dateTakenView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        dateTakenView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: frame.width * LayoutConstants.sideMarginRatio).isActive = true
    }

    private func set(imageState: ImageViewState) {
        switch imageState {
        case .loading:
            cellImageView.isHidden = true

        case let .image(image):
            cellImageView.isHidden = false
            cellImageView.image = image
        }
    }
}


// MARK: - FeedCellDisplaying

extension FeedViewCell: FeedCellDisplaying {
    func display(image: FeedCellModels.PhotoImage.ViewModel) {}

    func displayLoading() {}
}

// MARK: - ConfigurableFeedCell

extension FeedViewCell: ConfigurableFeedCell {
    func configure(interactor: FeedCellInteracting, photo: Photo) {
        self.interactor = interactor

        interactor.fetch(image: FeedCellModels.PhotoImage.Request(photoID: photo.id, url: photo.imageURL))
        
        if let metadata = photo.metadata {
            ownerNameView.text = metadata.ownerName
            dateTakenView.set(date: metadata.dateTaken)
            viewsView.set(views: metadata.views)
            tagsView.set(tags: metadata.tags)
        }
    }
}