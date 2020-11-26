//
// Created by Maxim Berezhnoy on 22/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

struct FeedModels {
    struct Photos {
        struct Request: Equatable {
            let startFromPosition: Int
            let fetchAtMost: Int
            let size: PhotoParameters.Size
            let metadata: [PhotoParameters.Metadata]
        }

        struct Response {
            let startingPosition: Int
            let photos: [Photo]
        }

        struct ViewModel {
            let photos: [Photo]
        }
    }
}
