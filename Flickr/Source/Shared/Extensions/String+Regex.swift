//
//  String+Regex.swift
//  Flickr
//
//  Created by luca silvestro on 26/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import Foundation

extension String {
    func substring(between chars: String) -> String {
        let pattern = "(?<=\(chars))(.*?)(?=\(chars))"
        
        if let range = range(of: pattern, options: .regularExpression) {
            return String(self[range])
        }
        
        return self
    }
}
