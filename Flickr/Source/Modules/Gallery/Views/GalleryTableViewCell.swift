//
//  GalleryTableViewCell.swift
//  Flickr
//
//  Created by luca silvestro on 26/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import UIKit
import SwiftDate
import Alamofire
import AlamofireImage

class GalleryTableViewCell: UITableViewCell {
    @IBOutlet var authorIconView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var photoView: UIImageView!
    
    override func prepareForReuse() {
        photoView.af_cancelImageRequest()
        super.prepareForReuse()
    }
}

// MARK: - Configurable
extension GalleryTableViewCell: Configurable {
    func configure(with model: Any?) {
        guard let model = model as? FlickrPhoto else { return }
        
        titleLabel.text = model.title
        authorLabel.text = model.authorFormatted
        authorIconView.tintColor = model.color
        dateLabel.text = model.dateFormatted()
        photoView.af_setImage(withURL: model.media.mobile,
                              placeholderImage: Constants.placeholder)
    }
}

// MARK: - Constants
extension GalleryTableViewCell {
    struct Constants {
        static let placeholder = #imageLiteral(resourceName: "photo_placeholder")
    }
}
