//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

protocol PhotoDataRetrieving {
    typealias Completion = (Result<Data, Error>) -> Void
    
    func retrieve(from url: URL, completion: @escaping Completion)
}