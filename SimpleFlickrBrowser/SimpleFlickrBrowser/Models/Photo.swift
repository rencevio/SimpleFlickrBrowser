//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import struct Foundation.URL
import struct Foundation.Date

struct Photo {
    struct Metadata {
        let views: Int
        let tags: [String]
        let ownerName: String
        let dateTaken: Date
    }
    
    typealias ID = String

    let id: ID
    let imageURL: URL
    let metadata: Metadata?
}
