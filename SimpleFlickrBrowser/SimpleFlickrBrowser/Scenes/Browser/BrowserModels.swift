//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

struct Photos {
    struct Request {
        let startFromPosition: Int
        let fetchAtMost: Int
        let searchCriteria: String? = nil
    }
    
    struct Response {
        let photos: [Photo]
    }
    
    struct ViewModel {
        let photos: [Photo]
    }
}