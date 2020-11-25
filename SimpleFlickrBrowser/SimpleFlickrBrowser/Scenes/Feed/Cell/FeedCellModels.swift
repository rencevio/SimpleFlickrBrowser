//
// Created by Maxim Berezhnoy on 25/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

struct FeedCellModels {
    struct PhotoImage {
        struct Request {
            let photoID: Photo.ID
            let url: URL
        }

        struct Response {
            let data: Data
        }

        struct ViewModel {
            let image: UIImage
        }
    }
}