//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

extension NSCache where KeyType == NSURL, ObjectType == NSData {
    func set(data: Data, forURL key: URL) {
        setObject(data as NSData, forKey: key as NSURL)
    }

    func getData(forURL url: URL) -> Data? {
        object(forKey: url as NSURL) as Data?
    }
}

final class PhotoDataNSCache: PhotoDataCaching {
    private let cache = NSCache<NSURL, NSData>()

    init(cacheSize: Int = 40_000_000) {
        cache.totalCostLimit = cacheSize
    }

    func store(data: Data, for url: URL) {
        cache.set(data: data, forURL: url)
    }

    func retrieve(from url: URL) -> Result<Data, CacheError> {
        if let cachedData = cache.getData(forURL: url) {
            return .success(cachedData)
        } else {
            return .failure(.nothingStored)
        }
    }
}