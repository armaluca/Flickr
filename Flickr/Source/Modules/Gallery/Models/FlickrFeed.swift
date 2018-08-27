//
//  FlickrFeed.swift
//  Flickr
//
//  Created by luca silvestro on 26/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import Foundation

struct FlickrFeed: Codable {
    var items: [FlickrPhoto]
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}
