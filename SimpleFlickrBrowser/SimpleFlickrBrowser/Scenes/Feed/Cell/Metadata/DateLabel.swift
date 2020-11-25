//
// Created by Maxim Berezhnoy on 26/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

final class DateLabel: UILabel {
    private let dateFormatter: DateFormatter

    init(dateFormat: String, frame: CGRect = .zero) {
        self.dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(date: Date) {
        text = dateFormatter.string(from: date)
    }
}