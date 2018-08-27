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

typealias Action = (() -> Void)

class GalleryStateView: UIView {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var primaryLabel: UILabel!
    @IBOutlet var secondaryLabel: UILabel!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!

    var action: Action?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.tintColor = Constants.Theme.pink
        actionButton.backgroundColor = Constants.Theme.blue
    }
    
    func prepare(for state: GalleryState, action: Action? = nil) {
        self.action = action
        
        prepareLabels(for: state)
        imageView.image = state == .error ? Constants.Content.Error.icon : Constants.Content.Empty.icon
    }
    
    private func prepareLabels(for state: GalleryState) {
        titleLabel.text = state == .error ? Constants.Content.Error.title : Constants.Content.Empty.title
        primaryLabel.text = state == .error ? Constants.Content.Error.primary : Constants.Content.Empty.primary
        secondaryLabel.text = state == .error ? Constants.Content.Error.secondary : Constants.Content.Empty.secondary
        
        let actionButtonTitle = state == .error ? Constants.Content.Error.button : Constants.Content.Empty.button
        actionButton.setTitle(actionButtonTitle, for: .normal)
    }
    
    @IBAction func didPressActionButton() {
        spinner.startAnimating()
        actionButton.isEnabled = false
        actionButton.backgroundColor = Constants.Theme.disabled
        action?()
    }
}

// MARK: - Constants
extension GalleryStateView {
    struct Constants {
        struct Theme {
            static let pink = UIColor(red: 1, green: 0, blue: 132/255, alpha: 1)
            static let blue = UIColor(red: 0, green: 99/255, blue: 219/255, alpha: 1)
            static let disabled = UIColor.gray
        }
        
        struct Content {
            struct Empty {
                static let icon = #imageLiteral(resourceName: "empty_state")
                static let title = "Hello there."
                static let primary = "The Flickr API provides a public feed that will retrieve the latest twenty photos."
                static let secondary = "It should be enough to fill the screen."
                static let button = "Start browsing"
            }
            
            struct Error {
                static let icon = #imageLiteral(resourceName: "error_state")
                static let title = "Damn it."
                static let primary = "I can't really say for sure what the problem is."
                static let secondary = "I just know for sure this never would have happened if Steve Jobs was still alive."
                static let button = "Try again"
            }
        }
    }
}
