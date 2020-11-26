//
// Created by Maxim Berezhnoy on 22/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

enum PhotoParameters {
    enum Size {
        case thumbSquare
        case medium
        case large
    }

    enum Metadata: CaseIterable {
        case views
        case tags
        case ownerName
        case dateTaken
    }
}