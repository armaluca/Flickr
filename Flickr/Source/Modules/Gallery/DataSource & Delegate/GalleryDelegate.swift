//
//  GalleryDelegate.swift
//  Flickr
//
//  Created by luca silvestro on 26/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import UIKit

class GalleryDelegate: NSObject, UITableViewDelegate, ExternalObjectViewInterfaceType {
    
    @IBOutlet var viewController: GalleryViewController!
    
    var items: [FlickrPhoto]? {
        return viewController.presenter.items
    }
}
