//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

final class PhotoDataNSCache: PhotoDataCaching {
    private let cache = NSCache<AnyObject, NSData>()

    init(cacheSize: Int = 40_000_000) {
        cache.totalCostLimit = cacheSize
    }

    func store(data: Data, for url: URL) {}

    func retrieve(from url: URL) -> Result<Data, CacheError> {
        fatalError("retrieve(from:) has not been implemented")
    }
}