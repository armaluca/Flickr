//
//  File.swift
//  Flickr
//
//  Created by luca silvestro on 26/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import UIKit

class GalleryDataSource: NSObject, UITableViewDataSource, ExternalObjectViewInterfaceType {

    @IBOutlet var viewController: GalleryViewController!
    
    var items: [FlickrPhoto]? {
        return viewController.presenter.items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = items?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.flickrCellIdentifier, for: indexPath)
        
        if let configurableCell = cell as? Configurable {
            configurableCell.configure(with: model)
        }
        
        return cell
    }
}

// MARK: - Constants
extension GalleryDataSource {
    struct Constants {
        static let flickrCellIdentifier = "FlickrCell"
    }
}
