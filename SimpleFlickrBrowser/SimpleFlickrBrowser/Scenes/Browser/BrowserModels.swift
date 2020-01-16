//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import struct Foundation.URL

// TODO: move somewhere else (root Models directory?)
struct Photo {
    typealias ID = String
    
    let id: ID
    let image: URL
}

struct Photos {
    struct Request {
        
    }
    
    struct Response {
        let photos: [Photo]
    }
    
    struct ViewModel {
        let photos: [Photo]
    }
}