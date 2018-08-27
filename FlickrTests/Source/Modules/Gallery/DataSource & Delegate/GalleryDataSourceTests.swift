//
//  GalleryDataSourceTests.swift
//  FlickrTests
//
//  Created by luca silvestro on 27/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import XCTest
@testable import Flickr

class GalleryDataSourceTests: XCTestCase {
    var subject: GalleryDataSource!
    var mockViewController: GalleryViewController!
    
    override func setUp() {
        super.setUp()
        subject = GalleryDataSource()
        subject.viewController = ControllerFactory.makeGalleryViewController()
    }
    
    override func tearDown() {
        subject = nil
        super.tearDown()
    }
    
    func testItemsAreTheSameCountAsPresenterItems() {
        guard let photos = subject.items,
              let presenterItems = subject.viewController.presenter.items else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(photos.count, presenterItems.count)
    }
    
    func testNumberOfRowsInSectionReturnsSameCountAsItems() {
        let countRows = subject.tableView(UITableView(), numberOfRowsInSection: 0)
        
        guard let photos = subject.items else {
                XCTFail()
                return
        }
        
        XCTAssertEqual(photos.count, countRows)
    }
    
    func testNumberOfRowsInSectionReturnsZeroIfItemsNil() {
        let mockPresenter = subject.viewController.presenter as? MockGalleryPresenter
        mockPresenter?.mockItems = nil
        let countRows = subject.tableView(UITableView(), numberOfRowsInSection: 0)
        XCTAssertEqual(0, countRows)
    }
    
    // To be Continued...
}

class ControllerFactory {
    static func makeGalleryViewController() -> GalleryViewController {
        let viewController = GalleryViewController()
        
        let mockTableView = MockTableView()
        let mockPresenter = MockGalleryPresenter()
        mockPresenter.mockItems = [makeModel()]
        let mockStateView = MockGalleryStateView()
        let mockRefreshControl = MockRefreshControl()
        
        viewController.tableView = mockTableView
        viewController.presenter = mockPresenter
        viewController.stateView = mockStateView
        viewController.refreshControl = mockRefreshControl
        
        return viewController
    }
}
