//
//  GalleryStateView.swift
//  Flickr
//
//  Created by luca silvestro on 27/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import UIKit

enum GalleryState {
    case empty
    case error
}

final class GalleryStateView: UIView {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var primaryLabel: UILabel!
    @IBOutlet var secondaryLabel: UILabel!
    @IBOutlet var actionButton: UIButton!

    private var action: (() -> Void)?
    
    func prepare(for state: GalleryState, action: (() -> Void)? = nil) {
        imageView.image = state == .error ? Constants.Content.Error.icon : Constants.Content.Empty.icon
        titleLabel.text = state == .error ? Constants.Content.Error.title : Constants.Content.Empty.title
        primaryLabel.text = state == .error ? Constants.Content.Error.primary : Constants.Content.Empty.primary
        secondaryLabel.text = state == .error ? Constants.Content.Error.secondary : Constants.Content.Empty.secondary
        
        actionButton.isHidden = state != .error
        self.action = action
    }
    
    @IBAction func didPressActionButton() {
        action?()
    }
}

// MARK: - Constants
extension GalleryStateView {
    struct Constants {
        struct Content {
            struct Empty {
                static let icon = #imageLiteral(resourceName: "empty_state")
                static let title = "Hello there."
                static let primary = "The Flickr API provides a public feed that will retrieve the latest twenty photos."
                static let secondary = "There should be plenty enough to fill the screen."
            }
            
            struct Error {
                static let icon = #imageLiteral(resourceName: "error_state")
                static let title = "Damn it."
                static let primary = "I can't really say for sure what the problem is."
                static let secondary = "I just know for sure this never would have happened if Steve Jobs was still alive."
            }
        }
    }
}
