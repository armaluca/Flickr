//
//  FlickrMedia.swift
//  Flickr
//
//  Created by luca silvestro on 26/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import Foundation

struct FlickrMedia: Codable {
    var mobile: URL
    
    enum CodingKeys: String, CodingKey {
        case mobile = "m"
    }
}
