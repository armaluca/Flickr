//
//  GalleryViewControllerTests.swift
//  FlickrTests
//
//  Created by luca silvestro on 27/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import XCTest
@testable import Flickr

class GalleryViewControllerTests: XCTestCase {
    
    var subject: GalleryViewController!
    var mockTableView: MockTableView!
    var mockPresenter: MockGalleryPresenter!
    var mockStateView: MockGalleryStateView!
    var mockRefreshControl: MockRefreshControl!
    
    override func setUp() {
        super.setUp()
        
        mockTableView = MockTableView()
        mockPresenter = MockGalleryPresenter()
        mockStateView = MockGalleryStateView()
        mockRefreshControl = MockRefreshControl()
        
        subject = GalleryViewController()
        subject.tableView = mockTableView
        subject.presenter = mockPresenter
        subject.stateView = mockStateView
        subject.refreshControl = mockRefreshControl
    }
    
    override func tearDown() {
        super.tearDown()
        subject = nil
    }
    
    func testViewDidLoadAddsRefreshControlToTableView() {
        subject.viewDidLoad()
        
        let refreshControl = mockTableView.viewAdded
        XCTAssertNotNil(refreshControl)
        XCTAssertTrue(refreshControl is UIRefreshControl)
    }
    
    func testViewDidLoadPreparesEmptyState() {
        mockStateView.onPrepareCalled = { state in
            XCTAssertTrue(state == .empty)
        }
        subject.viewDidLoad()
    }
    
    func testDidPullToRefreshCallsLoadOnPresenter() {
        let expect = expectation(description: "Should call load() method on the presenter")
        mockPresenter.onLoadCalled = {
            expect.fulfill()
        }
        subject.didPullToRefresh()
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testDidPullToRefreshStopsRefreshControl() {
        subject.didPullToRefresh()
        XCTAssertTrue(mockRefreshControl.didEndRefreshing)
    }
    
    func testReloadEventuallyReloadTableView() {
        let expect = expectation(description: "Should call reloadData on the tableView")
        
        mockTableView.onReloadData = {
            expect.fulfill()
        }
        
        subject.reload()

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testReloadEventuallyHidesStateView() {
        let expect = expectation(description: "Should hide GalleryStateView")
        
        mockStateView.onIsHiddenCalled = { hidden in
            if hidden {
                expect.fulfill()
            }
        }
        
        subject.reload()
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testShowErrorStateEventuallyShowsStateView() {
        let expect = expectation(description: "Should show GalleryStateView")
        
        mockStateView.onIsHiddenCalled = { hidden in
            if !hidden {
                expect.fulfill()
            }
        }
        
        subject.showErrorState(for: MockError())
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testShowErrorStateEventuallyPreparesEmptyState() {
        
    }
}
//MARK: - Mocks
class MockGalleryPresenter: GalleryPresenterInterface {
    var mockItems: [FlickrPhoto]? = [FlickrPhoto]()
    var onLoadCalled: (()->Void)?
    
    var items: [FlickrPhoto]? {
        return mockItems
    }
    
    func load() {
        onLoadCalled?()
    }
}
class MockTableView: UITableView {
    var viewAdded: UIView?
    var onReloadData: (()->Void)?
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        viewAdded = view
    }
    
    override func reloadData() {
        onReloadData?()
    }
}

class MockGalleryStateView: GalleryStateView {
    var onPrepareCalled:((GalleryState) -> Void)?
    var mockIsHidden: Bool = false
    var onIsHiddenCalled: ((Bool)->Void)?
    
    override func prepare(for state: GalleryState, action: (() -> Void)?) {
        onPrepareCalled?(state)
    }
    
    override var isHidden: Bool {
        get {
            return mockIsHidden
        }
        
        set {
            mockIsHidden = newValue
            onIsHiddenCalled?(newValue)
        }
    }
}

class MockRefreshControl: UIRefreshControl {
    var didEndRefreshing: Bool = false
    override func endRefreshing() {
        didEndRefreshing = true
    }
}

struct MockError: Error {}
