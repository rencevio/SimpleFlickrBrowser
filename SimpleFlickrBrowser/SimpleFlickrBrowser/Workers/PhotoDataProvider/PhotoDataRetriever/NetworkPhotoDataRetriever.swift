//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

final class NetworkPhotoDataRetriever: PhotoDataRetrieving {
    private let httpClient: HttpCommunicator

    init(httpClient: HttpCommunicator) {
        self.httpClient = httpClient
    }

    func retrieve(from url: URL, backgroundDownload: Bool, completion: @escaping Completion) {
        httpClient.get(url: url, background: backgroundDownload) { result in
            switch result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
