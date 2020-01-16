//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

protocol PhotoDataProviding {
    typealias Completion = (Result<Data, Error>) -> Void

    func getPhotoData(from url: URL, completion: @escaping Completion)
}

final class PhotoDataProvider: PhotoDataProviding {
    private let cache: PhotoDataCaching
    private let retriever: PhotoDataRetrieving
    
    private let operatingQueue = DispatchQueue(label: "\(PhotoDataProvider.self)OperatingQueue")

    init(cache: PhotoDataCaching, retriever: PhotoDataRetrieving) {
        self.cache = cache
        self.retriever = retriever
    }

    func getPhotoData(from url: URL, completion: @escaping Completion) {
        operatingQueue.async { [weak self] in 
            guard let self = self else { return }
            
            let cacheResult = self.cache.retrieve(from: url)

            switch cacheResult {
            case .success(let data):
                completion(.success(data))
            case .failure:
                self.retrievePhotoData(from: url, completion: completion)
            }
        }
    }

    private func retrievePhotoData(from url: URL, completion: @escaping Completion) {
        retriever.retrieve(from: url) { [weak cache] result in
            switch result {
            case .success(let data):
                cache?.store(data: data, for: url)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}