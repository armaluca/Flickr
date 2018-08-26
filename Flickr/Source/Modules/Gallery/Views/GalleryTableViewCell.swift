//
//  GalleryTableViewCell.swift
//  Flickr
//
//  Created by luca silvestro on 26/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {
    @IBOutlet var authorIconView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var photoView: UIImageView!
    
}

// MARK: - Configurable
extension GalleryTableViewCell: Configurable {
    func configure(with model: Any?) {
        guard let flickrPhoto = model as? FlickrPhoto else { return }
        
        titleLabel.text = flickrPhoto.title
        authorLabel.text = flickrPhoto.author
        //TODO: format date, fetch image and randomize author icon color
    }
}
