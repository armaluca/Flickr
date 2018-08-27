//
//  GalleryTableViewCellTests.swift
//  FlickrTests
//
//  Created by luca silvestro on 27/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import XCTest
@testable import Flickr
import Alamofire
import AlamofireImage

class GalleryTableViewCellTests: XCTestCase {
    
    var subject: GalleryTableViewCell!
    var mockImageView: MockImageView!
    var authorImageView = UIImageView()
    
    override func setUp() {
        authorImageView.tintColor = .black
        mockImageView = MockImageView()
        
        subject = GalleryTableViewCell()
        subject.authorIconView = authorImageView
        subject.authorLabel = UILabel()
        subject.dateLabel = UILabel()
        subject.photoView = mockImageView
        subject.titleLabel = UILabel()
        
        super.setUp()
    }
    
    override func tearDown() {
        subject = nil
        super.tearDown()
    }
    
    func testConfigureDoNotSetAnyPropertyIfModelIsNil() {
        subject.configure(with: nil)
        
        XCTAssertEqual(subject.authorIconView.tintColor, .black)
        XCTAssertNil(subject.authorLabel.text)
        XCTAssertNil(subject.dateLabel.text)
        XCTAssertNil(subject.titleLabel.text)
    }
    
    func testConfigureDoNotSetAnyPropertyIfModelIsNotFlickrPhoto() {
        subject.configure(with: 1)
        
        XCTAssertEqual(subject.authorIconView.tintColor, .black)
        XCTAssertNil(subject.authorLabel.text)
        XCTAssertNil(subject.dateLabel.text)
        XCTAssertNil(subject.titleLabel.text)
    }
    
    func testConfigureSetsPropertiesWhenModelIsFlickrPhoto() {
        let url = URL(string: "https://httpbin.org/image/jpeg")!
        let media = FlickrMedia(mobile: url)
        
        let model = FlickrPhoto(title: "title",
            link: url,
            date: Date(),
            author: "author",
            media: media)
        
        let expect = expectation(description: "Image should download successfully")
        
        mockImageView = MockImageView {
            expect.fulfill()
        }
        
        subject.photoView = mockImageView
        subject.configure(with: model)
        
        let expectedTintColor = UIColor.random(seed: model.author)
        XCTAssertEqual(subject.authorIconView.tintColor, expectedTintColor)
        XCTAssertNotNil(subject.authorLabel.text)
        XCTAssertNotNil(subject.dateLabel.text)
        XCTAssertNotNil(subject.titleLabel.text)
    
        waitForExpectations(timeout: 1, handler: nil)
    }
}

class MockImageView: UIImageView {
    var imageObserver: (() -> Void)?
    
    convenience init(imageObserver: (() -> Void)? = nil) {
        self.init(frame: CGRect.zero)
        self.imageObserver = imageObserver
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var image: UIImage? {
        get {
            return super.image
        }
        set {
            super.image = newValue
            imageObserver?()
        }
    }
}

