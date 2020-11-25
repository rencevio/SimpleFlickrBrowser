//
// Created by Maxim Berezhnoy on 24/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol ConfigurableFeedCell: FeedCellDisplaying {
    func configure(interactor: FeedCellInteracting, photo: Photo)
}
