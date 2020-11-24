//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

protocol PhotoCollectionFetching {
    typealias Completion = (Result<[Photo], Error>) -> Void

    func fetchPhotos(startingFrom position: Int,
                     fetchAtMost maxFetchCount: Int,
                     matching searchCriteria: String?,
                     withSize size: PhotoParameters.Size,
                     includeMetadata metadata: [PhotoParameters.Metadata],
                     completion: @escaping Completion
    )
}
