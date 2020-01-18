//
// Created by Maxim Berezhnoy on 17/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

struct FlickrPhoto: Decodable {
    let id: String
    let secret: String
    let server: String
    let farm: String
}