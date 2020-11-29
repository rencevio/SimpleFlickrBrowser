//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import struct Foundation.Data
import struct Foundation.Date
import struct Foundation.URL

struct Photo {
    struct Metadata {
        let views: Int
        let tags: [String]
        let ownerName: String
        let dateTaken: Date
    }

    typealias ID = String

    let id: ID
    let imageData: Data
    let fullSizeImageURL: URL
    let metadata: Metadata
}
