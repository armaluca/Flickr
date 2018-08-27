//
//  GalleryServiceTests.swift
//  FlickrTests
//
//  Created by luca silvestro on 27/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import XCTest
@testable import Flickr

class GalleryServiceTests: XCTestCase {
    var subject: GalleryService!
    var mockSession: MockURLSession!
    var mockTask: MockTask!
    
    override func setUp() {
        super.setUp()
        
        let task = MockTaskMaker().makeTask(for: GalleryService.Constants.Feed.endpoint,
                                            statusCode: 200,
                                            data: PublicFeedDataFactory.makePublicFeedData())
        
        guard let fakeTask = task as? MockTask else {
            XCTFail()
            return
        }
        
        mockTask = fakeTask
        mockSession = MockURLSession()
        mockSession.mockedTasks = [mockTask]
        subject = GalleryService(session: mockSession)
    }
    
    override func tearDown() {
        subject = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testLoadFeed200Successful() {
        let expect = expectation(description: "Should call completion when task return status 200")
        
        subject.loadFeed { error, items in
            guard let items = items else {
                XCTFail()
                return
            }
            
            XCTAssertNil(error)
            XCTAssertTrue(items is [FlickrPhoto])
            expect.fulfill()
        }
        
        XCTAssertTrue(mockTask.isResumeCalled)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoadFeed404Unsuccessful() {
        let expect = expectation(description: "Should call completion with error and no items when task return status 404")
        
        let failedTask = MockTaskMaker().makeTask(for: GalleryService.Constants.Feed.endpoint,
                                            statusCode: 404,
                                            data: PublicFeedDataFactory.makePublicFeedData())
        
        mockTask = failedTask as? MockTask
        mockSession.mockedTasks = [mockTask]
        
        subject.loadFeed { error, items in
            XCTAssertNotNil(error)
            XCTAssertNil(items)
            
            guard let error = error else {
                XCTFail()
                return
            }
            
            XCTAssertTrue(error is NetworkError)
            expect.fulfill()
        }
        
        XCTAssertTrue(mockTask.isResumeCalled)
        waitForExpectations(timeout: 1, handler: nil)
    }
}

class PublicFeedDataFactory {
    static func makePublicFeedData() -> Data? {
        if let path = Bundle(for: GalleryServiceTests.self).path(forResource: "MockFeed", ofType: "json") {
            return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        }
        
        return nil
    }
}
