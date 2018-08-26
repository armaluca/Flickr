//
//  FlickrPhoto.swift
//  Flickr
//
//  Created by luca silvestro on 26/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import Foundation

struct FlickrPhoto: Codable {
    var title: String
    var link: URL
    var date: Date
    var author: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case link
        case date = "published"
        case author
    }
}
