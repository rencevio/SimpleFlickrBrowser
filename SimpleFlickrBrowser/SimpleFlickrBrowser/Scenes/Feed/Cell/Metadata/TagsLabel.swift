//
// Created by Maxim Berezhnoy on 26/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

class TagsLabel: UILabel {
    func set(tags: [String]) {
        super.text = tags.joined(separator: ", ")
    }
}