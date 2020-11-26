//
// Created by Maxim Berezhnoy on 26/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation.NSDate

extension String {
    func toInt() -> Int? {
        Int(self)
    }
    
    func toDate(formatter: DateFormatter) -> Date? {
        formatter.date(from: self)
    }
}