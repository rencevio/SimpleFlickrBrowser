//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

protocol PhotoDataProviding {
    typealias Completion = (Result<Data, Error>) -> Void

    func getPhotoData(from url: URL, backgroundDownload: Bool, _ completion: @escaping Completion)
}

final class PhotoDataProvider: PhotoDataProviding {
    private let cache: PhotoDataCaching
    private let retriever: PhotoDataRetrieving

    private let operatingQueue = DispatchQueue(label: "\(PhotoDataProvider.self)OperatingQueue")

    init(cache: PhotoDataCaching, retriever: PhotoDataRetrieving) {
        self.cache = cache
        self.retriever = retriever
    }

    func getPhotoData(from url: URL, backgroundDownload: Bool, _ completion: @escaping Completion) {
        operatingQueue.async { [weak self] in
            guard let self = self else { return }

            let cacheResult = self.cache.retrieve(from: url)

            switch cacheResult {
            case let .success(data):
                completion(.success(data))
            case .failure:
                self.retrievePhotoData(from: url, backgroundDownload: backgroundDownload, completion: completion)
            }
        }
    }

    private func retrievePhotoData(from url: URL, backgroundDownload: Bool, completion: @escaping Completion) {
        retriever.retrieve(from: url, backgroundDownload: backgroundDownload) { [weak cache] result in
            switch result {
            case let .success(data):
                cache?.store(data: data, for: url)
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
