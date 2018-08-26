//
//  GalleryService.swift
//  Flickr
//
//  Created by luca silvestro on 26/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import Foundation

final class GalleryService: GalleryNetworkingService {
    
    func loadFeed(completion: NetworkingCompletion) {
        
    }
}

extension GalleryService {
    struct Constants {
        struct Feed {
            static let endpoint = "https://api.flickr.com/services/feeds/photos_public?format=json"
        }
    }
}

