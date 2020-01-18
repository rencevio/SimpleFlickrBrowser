//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import struct Foundation.URL

struct Photo {
    typealias ID = String

    let id: ID
    let image: URL
}
