//
//  FlickrPhoto.swift
//  Flickr
//
//  Created by luca silvestro on 26/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import UIKit
import SwiftDate

struct FlickrPhoto: Codable {
    var title: String
    var link: URL
    var date: Date
    var author: String
    var media: FlickrMedia
    
    var color: UIColor {
        return UIColor.random(seed: author)
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case link
        case date = "published"
        case author
        case media
    }
}

// MARK: - Formatting
extension FlickrPhoto {
    var authorFormatted: String {
        return author.substring(between: "\"")
    }
    
    func dateFormatted(style: RelativeFormatter.Style = RelativeFormatter.defaultStyle(), locale: Locales = Locales.english) -> String {
        return date.toRelative(style: style, locale: locale)
    }
}
