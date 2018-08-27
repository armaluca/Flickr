//
//  GalleryDataInteractorTests.swift
//  FlickrTests
//
//  Created by luca silvestro on 27/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import XCTest
@testable import Flickr

class GalleryDataInteractorTests: XCTestCase {
    var subject: GalleryDataInteractor!
    var mockService: MockGalleryService!
    var mockDelegate: MockDelegate!
    
    override func setUp() {
        super.setUp()
        mockService = MockGalleryService()
        mockDelegate = MockDelegate()
        
        subject = GalleryDataInteractor(service: mockService)
        subject.delegate = mockDelegate
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchModelsShouldCallServiceLoadFeed() {
        subject.fetchModels()
        
        XCTAssertTrue(mockService.isLoadFeedCalled)
    }
    
    func testFetchModelsShouldEventuallyCallDelegateIfAnErrorHappens() {
        mockService.shouldReturnError = true
        subject.fetchModels()
        
        XCTAssertTrue(mockDelegate.isDataInteractorDidFinishFetchWithFailureCalled)
    }
    
    func testFetchModelsShouldEventuallyCallDelegateIfSuccessful() {
        mockService.shouldReturnError = false
        subject.fetchModels()
        
        XCTAssertTrue(mockDelegate.isDataInteractorDidFinishFetchCalled)
    }
}

class MockGalleryService: GalleryNetworkingServiceInterface {
    var isLoadFeedCalled = false
    var shouldReturnError = false
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }
    
    func loadFeed(completion: @escaping NetworkingCompletion) {
        isLoadFeedCalled = true
        
        if shouldReturnError {
            let error = MockError()
            completion(error, nil)
        } else {
            if let path = Bundle(for: type(of: self)).path(forResource: "MockFeed", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let feed = try decoder.decode(FlickrFeed.self, from: data)
                    completion(nil, feed)
                    
                } catch {
                    XCTFail()
                }
            }
        }
    }
}

class MockDelegate: DataInteractorDelegateInterface {
    var isDataInteractorDidFinishFetchCalled = false
    var isDataInteractorDidFinishFetchWithFailureCalled = false
    
    func dataInteractorDidFinishFetch(model: Any?) {
        isDataInteractorDidFinishFetchCalled = true
    }
    
    func dataInteractorDidFinishFetchWithFailure(error: Error) {
        isDataInteractorDidFinishFetchWithFailureCalled = true
    }
}
