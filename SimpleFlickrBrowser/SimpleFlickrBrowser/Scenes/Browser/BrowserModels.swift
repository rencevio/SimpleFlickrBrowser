//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

struct Photos {
    struct Request: Equatable {
        let startFromPosition: Int
        let fetchAtMost: Int
        let searchCriteria: String
    }

    struct Response {
        let startingPosition: Int
        let photos: [Photo]
    }

    struct ViewModel {
        let photos: [Photo]
    }
}
