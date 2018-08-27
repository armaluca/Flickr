//
//  GalleryPresenterTests.swift
//  FlickrTests
//
//  Created by luca silvestro on 27/08/18.
//  Copyright © 2018 luca silvestro. All rights reserved.
//

import XCTest
@testable import Flickr
class GalleryPresenterTests: XCTestCase {
    var subject: GalleryPresenter!
    var mockView: MockGalleryView!
    var mockDataInteractor: MockGalleryDataInteractor!
    var mockWireframe: MockGalleryWireframe!
    
    override func setUp() {
        super.setUp()
        mockView = MockGalleryView()
        mockDataInteractor = MockGalleryDataInteractor()
        mockWireframe = MockGalleryWireframe()
        subject = GalleryPresenter(wireframe: mockWireframe,
                                   view: mockView,
                                   dataInteractor: mockDataInteractor)
    }
    
    override func tearDown() {
        subject = nil
        super.tearDown()
    }
    
    func testViewDidLoadShouldCallFetchModelsMethodOnDataInteractor() {
        subject.viewDidLoad()
        
        XCTAssertTrue(mockDataInteractor.isFetchModelsCalled)
    }
    
    func testLoadShouldCallFetchModelsMethodOnDataInteractor() {
        subject.load()
        
        XCTAssertTrue(mockDataInteractor.isFetchModelsCalled)
    }
    
    func testDataInteractorDidFinishFetchWithCorrectModel() {
        let model = makeModel()
        
        subject.dataInteractorDidFinishFetch(model: [model])
        
        guard let items = subject.items,
              let firstItem = items.first else {
                XCTFail("Items array should not be nil")
                return
        }

        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(firstItem.title, model.title)
        XCTAssertTrue(mockView.isReloadCalled)
    }
    
    func testDataInteractorDidFinishFetchWithWrongModel() {
        subject.dataInteractorDidFinishFetch(model: [1])
        
        XCTAssertNil(subject.items)
        XCTAssertFalse(mockView.isReloadCalled)
    }
}

class MockGalleryWireframe: GalleryWireframeInterface {
    func popFromNavigationController(animated: Bool) {}
    func dismiss(animated: Bool) {}
    func navigate(to option: GalleryNavigationOption) {}
}

class MockGalleryView: GalleryViewInterface {
    var isReloadCalled = false
    var presenter: GalleryPresenterInterface!
    
    func reload() {
        isReloadCalled = true
    }
    
    func showErrorState(for error: Error) {
        
    }
}

class MockGalleryDataInteractor: GalleryDataInteractorInterface {
    var isFetchModelsCalled = false
    func fetchModels() {
        isFetchModelsCalled = true
    }
}

func makeModel() -> FlickrPhoto {
    let url = URL(string: "https://httpbin.org/image/jpeg")!
    let media = FlickrMedia(mobile: url)
    
    let model = FlickrPhoto(title: "myTitle",
                            link: url,
                            date: Date(),
                            author: "author",
                            media: media)
    
    return model
}
