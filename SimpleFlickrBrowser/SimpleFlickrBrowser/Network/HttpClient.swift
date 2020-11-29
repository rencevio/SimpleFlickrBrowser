//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

protocol HttpCommunicator {
    typealias Completion = (Result<Data, Http.RequestError>) -> Void
    func get(url: URL, background: Bool, completion: @escaping Completion)
}

enum Http {
    enum RequestError: Error {
        case noData
        case httpError(Error)
    }

    final class Client: HttpCommunicator {
        private let urlSession = URLSession.shared
        private let backgroundUrlSession = URLSession.sharedBackground

        func get(url: URL, background: Bool, completion: @escaping Completion) {
            let session: NetworkSession = background ? backgroundUrlSession : urlSession

            session.getData(from: url) { data, error in
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
        }
    }
}
