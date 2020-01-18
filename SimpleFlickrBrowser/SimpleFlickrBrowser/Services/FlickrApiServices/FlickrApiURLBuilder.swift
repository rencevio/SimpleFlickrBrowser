//
// Created by Maxim Berezhnoy on 18/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

final class FlickrApiURLResolver {
    static let host = "www.flickr.com"
    static let apiPath = "/services/rest"

    static func build(method: FlickrApiValues.Method,
                      apiKey: String,
                      queryParameters: [FlickrApiValues.QueryParameter: String],
                      format: String = "json") -> URL {
        let defaultQueryParameters: [FlickrApiValues.QueryParameter: String] = [
            .method: method.rawValue,
            .apiKey: apiKey,
            .format: format,
            .noJsonCallback: "1"
        ]

        let resolvedQueryParameters = defaultQueryParameters.merging(queryParameters) { $1 }

        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = apiPath
        urlComponents.queryItems = resolvedQueryParameters.map { URLQueryItem(name: $0.key.rawValue, value: $0.value) }

        guard let builtUrl = urlComponents.url else {
            fatalError("Unable to build url from method: \(method), apiKey: \(apiKey), queryParams: \(queryParameters)")
        }

        return builtUrl
    }
}