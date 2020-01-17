//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

final class NetworkPhotoDataRetriever: PhotoDataRetrieving {
    let httpClient: HttpCommunicator

    init(httpClient: HttpCommunicator) {
        self.httpClient = httpClient
    }

    func retrieve(from url: URL, completion: @escaping Completion) {
        httpClient.get(url: url) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}