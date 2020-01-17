//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

protocol HttpCommunicator {
    typealias Completion = (Result<Data, Http.RequestError>) -> Void
    func get(url: URL, completion: @escaping Completion)
}

enum Http {
    enum RequestError: Error {
        case noData
        case httpError(Error)
    }

    final class Client: HttpCommunicator {
        private let urlSession = URLSession.shared

        func get(url: URL, completion: @escaping Completion) {
            let task = urlSession.dataTask(with: url) { data, _, error in
                guard let data = data else {
                    if let error = error {
                        completion(.failure(.httpError(error)))
                    } else {
                        completion(.failure(.noData))
                    }
                    
                    return
                }

                completion(.success(data))
            }
            
            task.resume()
        }
    }
}
