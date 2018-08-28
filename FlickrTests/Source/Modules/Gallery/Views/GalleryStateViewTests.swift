//
//  GalleryStateViewTests.swift
//  FlickrTests
//
//  Created by luca silvestro on 27/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import XCTest
@testable import Flickr

class GalleryStateViewTests: XCTestCase {
    var subject: GalleryStateView!
    var mockSpinner: MockActivityIndicatorView!
    override func setUp() {
        super.setUp()
        
        mockSpinner = MockActivityIndicatorView()
        
        subject = GalleryStateView()
        subject.imageView = UIImageView()
        subject.titleLabel = UILabel()
        subject.primaryLabel = UILabel()
        subject.secondaryLabel = UILabel()
        subject.actionButton = UIButton()
        subject.spinner = mockSpinner
    }
    
    override func tearDown() {
        subject = nil
        super.tearDown()
    }
    
    func testAwakeFromNibSetsTintColorToImageView() {
        subject.awakeFromNib()
        
        XCTAssertEqual(subject.imageView.tintColor, GalleryStateView.Constants.Theme.pink)
    }
    
    func testPrepareLabelsForEmptyState() {
        subject.prepare(for: .empty)
        
        XCTAssertEqual(subject.titleLabel.text, GalleryStateView.Constants.Content.Empty.title)
        XCTAssertEqual(subject.primaryLabel.text, GalleryStateView.Constants.Content.Empty.primary)
        XCTAssertEqual(subject.secondaryLabel.text, GalleryStateView.Constants.Content.Empty.secondary)
        
    XCTAssertEqual(subject.actionButton.title(for: .normal), GalleryStateView.Constants.Content.Empty.button)
    }
    
    func testPrepareImageForEmptyState() {
        subject.prepare(for: .empty)
        
        XCTAssertEqual(subject.imageView.image, GalleryStateView.Constants.Content.Empty.icon)
    }
    
    func testPrepareForEmptyStateWithActionSetsAction() {
        subject.prepare(for: .empty) {}
        
        XCTAssertNotNil(subject.action)
    }
    
    func testPrepareForEmptyStateWithoutActionDoNotSetAction() {
        subject.prepare(for: .empty)
        
        XCTAssertNil(subject.action)
    }
    
    func testPrepareLabelsForErrorState() {
        subject.prepare(for: .error)
        
        XCTAssertEqual(subject.titleLabel.text, GalleryStateView.Constants.Content.Error.title)
        XCTAssertEqual(subject.primaryLabel.text, GalleryStateView.Constants.Content.Error.primary)
        XCTAssertEqual(subject.secondaryLabel.text, GalleryStateView.Constants.Content.Error.secondary)
        XCTAssertEqual(subject.actionButton.title(for: .normal), GalleryStateView.Constants.Content.Error.button)
    }
    
    func testPrepareIsResettingStates() {
        subject.prepare(for: .empty)
        
        XCTAssertEqual(subject.actionButton.backgroundColor, GalleryStateView.Constants.Theme.blue)
        XCTAssertTrue(mockSpinner.isStopAnimatingCalled)
        XCTAssertTrue(subject.actionButton.isEnabled)
    }
    
    func testPrepareImageForErrorState() {
        subject.prepare(for: .error)
        
        XCTAssertEqual(subject.imageView.image, GalleryStateView.Constants.Content.Error.icon)
    }
    
    func testPrepareForErrorStateWithActionSetsAction() {
        subject.prepare(for: .error) {}
        
        XCTAssertNotNil(subject.action)
    }
    
    func testPrepareForErrorStateWithoutActionDoNotSetAction() {
        subject.prepare(for: .error)
        
        XCTAssertNil(subject.action)
    }
    
    func testDidPressActionButtonCallsClosure() {
        let expect = expectation(description: "Should call the closure")
        
        subject.action = {
            expect.fulfill()
        }
        
        subject.didPressActionButton()
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testDidPressActionButtonStartsSpinner() {
        subject.didPressActionButton()
        
        XCTAssertTrue(mockSpinner.isStartAnimatingCalled)
    }
    
    func testDidPressActionButtonDisablesActionButton() {
        subject.didPressActionButton()
        XCTAssertFalse(subject.actionButton.isEnabled)
    }
    
    func testDidPressActionButtonSetsActionButtonBackgroundColor() {
        subject.didPressActionButton()
        
        XCTAssertEqual(subject.actionButton.backgroundColor, GalleryStateView.Constants.Theme.disabled)
    }
}

class MockActivityIndicatorView: UIActivityIndicatorView {
    var isStartAnimatingCalled = false
    var isStopAnimatingCalled = false
    override func startAnimating() {
        isStartAnimatingCalled = true
    }
    
    override func stopAnimating() {
        isStopAnimatingCalled = true
    }
}
