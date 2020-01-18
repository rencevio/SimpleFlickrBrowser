//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import UIKit

struct PhotoImage {
    struct Request {
        let photoID: Photo.ID
        let url: URL
    }
    
    struct Response {
        let data: Data
    }
    
    struct ViewModel {
        let image: UIImage
    }
}