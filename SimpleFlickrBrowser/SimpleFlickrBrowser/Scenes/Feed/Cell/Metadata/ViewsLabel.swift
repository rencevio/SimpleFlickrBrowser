//
// Created by Maxim Berezhnoy on 26/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

final class ViewsLabel: UILabel {
    func set(views: Int) {
        let description = views == 1 ? "view" : "views"
        super.text = "\(views) \(description)"
    }
}
