//
//  FlickrPhotoTests.swift
//  FlickrTests
//
//  Created by luca silvestro on 27/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import XCTest
@testable import Flickr

class FlickrPhotoTests: XCTestCase {
    var subject: FlickrPhoto!
    
    override func setUp() {
        super.setUp()
        subject = makeModel()
    }
    
    override func tearDown() {
        super.tearDown()
        subject = nil
    }
    
    func testAuthorFormattedWithCorrectPattern() {
        subject.author = "hello \"John\""
        XCTAssertEqual(subject.authorFormatted, "John")
    }
    
    func testAuthorFormattedWithWrongPattern() {
        subject.author = "hello \"John"
        XCTAssertEqual(subject.authorFormatted, subject.author)
    }
}
