//
// Created by Maxim Berezhnoy on 29/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation.NSData

struct FullImageModels {
    struct Image {
        struct Request {
            let url: URL
        }

        struct Response {
            let image: Data
        }

        struct ViewModel {
            let image: Data
        }
    }
}