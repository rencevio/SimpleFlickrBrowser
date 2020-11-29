//
// Created by Maxim Berezhnoy on 29/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

protocol NetworkSession {
    typealias Completion = (Data?, Error?) -> Void
    
    func getData(from url: URL, _ completion: @escaping Completion)
}

extension URLSession: NetworkSession {
    func getData(from url: URL, _ completion: @escaping Completion) {
        dataTask(with: url) { data, _, error in
            completion(data, error)
        }.resume()
    }
}