//
// Created by Maxim Berezhnoy on 27/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation.NSData

protocol FlickrCollectionDataFetching {
    func fetchData(photos: [FlickrPhoto], withSize size: PhotoParameters.Size, _ completion: @escaping ([Photo.ID: Data]) -> Void)
}