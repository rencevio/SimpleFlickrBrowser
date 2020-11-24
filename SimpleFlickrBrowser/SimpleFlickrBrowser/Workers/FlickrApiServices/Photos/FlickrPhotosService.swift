//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

protocol FlickrPhotosFetching {
    typealias Completion = (Result<[FlickrPhoto], Error>) -> Void

    func getRecent(page: Int, photosPerPage: Int, includeMetadata metadata: [PhotoParameters.Metadata], completion: @escaping Completion)

    func search(matching text: String, page: Int, photosPerPage: Int, includeMetadata metadata: [PhotoParameters.Metadata], completion: @escaping Completion)
}

final class FlickrPhotosService: FlickrPhotosFetching {
    private let apiKey: String
    private let httpClient: HttpCommunicator

    init(apiKey: String, httpClient: HttpCommunicator) {
        self.apiKey = apiKey
        self.httpClient = httpClient
    }

    func getRecent(page: Int, photosPerPage: Int, includeMetadata metadata: [PhotoParameters.Metadata], completion: @escaping Completion) {
        let url = FlickrApiURLResolver.build(
            method: .photosGetRecent,
            apiKey: apiKey,
            queryParameters: [
                .page: String(page),
                .perPage: String(photosPerPage),
            ]
        )

        fetchFrom(url: url, completion: completion)
    }

    func search(matching text: String, page: Int, photosPerPage: Int, includeMetadata metadata: [PhotoParameters.Metadata], completion: @escaping Completion) {
        let url = FlickrApiURLResolver.build(
            method: .photosSearch,
            apiKey: apiKey,
            queryParameters: [
                .text: text,
                .page: String(page),
                .perPage: String(photosPerPage),
                .extras: getQueryParameters(for: metadata).map { $0.rawValue }.joined(separator: ",")
            ]
        )

        fetchFrom(url: url, completion: completion)
    }

    private func fetchFrom(url: URL, completion: @escaping Completion) {
        httpClient.get(url: url) { [weak self] result in
            guard let self = self else { return }

            let photosResponse = self.parse(response: result)

            switch photosResponse {
            case let .success(response):
                let filteredPhotos = response.photos.photo.filter { $0.farm != 0 }

                completion(.success(filteredPhotos))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func parse(response: Result<Data, Http.RequestError>) -> Result<FlickrPhotosResponse, Error> {
        switch response {
        case let .success(data):
            do {
                let photosResponse = try JSONDecoder().decode(FlickrPhotosResponse.self, from: data)
                return .success(photosResponse)
            } catch {
                return .failure(error)
            }
        case let .failure(error):
            return .failure(error)
        }
    }
    
    private func getQueryParameters(for metadata: [PhotoParameters.Metadata]) -> [FlickrApiValues.PhotoMetadata] {
        metadata.map {
            switch ($0) {
            case .views:
                return .views
            case .tags:
                return .tags
            case .ownerName:
                return .ownerName
            case .dateTaken:
                return .dateTaken
            }
        }
    }
}
