//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

protocol FlickrPhotosFetching {
    typealias Completion = (Result<[FlickrPhoto], Error>) -> Void

    func getRecent(page: Int, photosPerPage: Int, completion: @escaping Completion)

    func search(matching text: String, page: Int, photosPerPage: Int, completion: @escaping Completion)
}

final class FlickrPhotosService: FlickrPhotosFetching {
    private let apiKey: String
    private let httpClient: HttpCommunicator

    init(apiKey: String, httpClient: HttpCommunicator) {
        self.apiKey = apiKey
        self.httpClient = httpClient
    }

    func getRecent(page: Int, photosPerPage: Int, completion: @escaping Completion) {
        let url = FlickrApiURLResolver.build(
                method: .photosGetRecent,
                apiKey: apiKey,
                queryParameters: [
                    .page: String(page),
                    .perPage: String(photosPerPage)
                ])

        fetchFrom(url: url, completion: completion)
    }

    func search(matching text: String, page: Int, photosPerPage: Int, completion: @escaping Completion) {
        let url = FlickrApiURLResolver.build(
                method: .photosGetRecent,
                apiKey: apiKey,
                queryParameters: [
                    .text: text,
                    .page: String(page),
                    .perPage: String(photosPerPage)
                ])

        fetchFrom(url: url, completion: completion)
    }

    private func fetchFrom(url: URL, completion: @escaping Completion) {
        httpClient.get(url: url) { [weak self] result in
            guard let self = self else { return }

            let photosResponse = self.parse(response: result)

            switch photosResponse {
            case .success(let response):
                completion(.success(response.photos.photo))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func parse(response: Result<Data, Http.RequestError>) -> Result<FlickrPhotosResponse, Error> {
        switch response {
        case .success(let data):
            do {
                let photosResponse = try JSONDecoder().decode(FlickrPhotosResponse.self, from: data)
                return .success(photosResponse)
            } catch (let error) {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}