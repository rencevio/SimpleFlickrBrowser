//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

enum CacheError: Error {
    case nothingStored
}

protocol PhotoDataCaching: AnyObject {
    func store(data: Data, for url: URL)
    func retrieve(from url: URL) -> Result<Data, CacheError>
}
