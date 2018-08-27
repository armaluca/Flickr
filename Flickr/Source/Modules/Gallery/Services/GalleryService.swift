//
//  GalleryService.swift
//  Flickr
//
//  Created by luca silvestro on 26/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import Foundation

final class GalleryService: GalleryNetworkingService {
    private let defaultSession: URLSession
    private var dataTask: URLSessionDataTask?
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.defaultSession = session
    }
    
    func loadFeed(completion: @escaping NetworkingCompletion) {
        dataTask?.cancel()
        
        guard let url = URL(string: Constants.Feed.endpoint) else {
            return
        }
        
        dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer { self?.dataTask = nil }
            
            if let error = error {
               completion(error, nil)
               return
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                    do {
                        let feed = try self?.decoder.decode(FlickrFeed.self, from: data)
                        completion(nil, feed?.items)
                    } catch {
                        completion(error, nil)
                    }
            }
        }
        
        dataTask?.resume()
    }
}

extension GalleryService {
    struct Constants {
        struct Feed {
            static let endpoint = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
        }
    }
}

