import XCTest

class MockURLSession: URLSession {
    var mockedTasks: [URLSessionDataTask]?
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        return findMockTask(for: url, completion: completionHandler)
    }

    override func dataTask(with url: URL) -> URLSessionDataTask {
        
        return findMockTask(for: url, completion: nil)
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        return findMockTask(for: request.url, completion: completionHandler)
    }
    

    private func findMockTask(for url: URL?, completion: ((Data?, URLResponse?, Error?) -> Void)?) -> URLSessionDataTask {
        
        guard let url = url else {
            XCTFail()
            return URLSessionDataTask()
        }
        
        let optionalTask = mockedTasks?.first(where: { (task) -> Bool in
            return task.response?.url?.absoluteString == url.absoluteString
        })
        
        guard let task = optionalTask else {
            XCTFail("There is no mock-task for the URL specified")
            return URLSessionDataTask()
        }
        
        guard let mockTask = task as? MockTask else {
            XCTFail("There is no mock-task for the URL specified")
            return URLSessionDataTask()
        }
        
        mockTask.completionHandler = completion
        
        return mockTask
    }
}

class MockTask: URLSessionDataTask {
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    public var isResumeCalled = false
    public var isCanceledCalled = false
    
    private var mockData: Data?
    private var mockError: Error?
    private var mockResponse: URLResponse?
    
    override var response: URLResponse? {
        return mockResponse
    }
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        mockData = data
        mockError = error
        mockResponse = response
    }
    
    override func resume() {
        isResumeCalled = true
        completionHandler?(mockData, mockResponse, mockError)
    }
    
    override func cancel() {
        isCanceledCalled = true
    }
}

class MockResponse: HTTPURLResponse {
    private var mockStatusCode: Int = 404
    
    override var statusCode: Int {
        return mockStatusCode
    }
    
    init(url: URL, statusCode: Int) {
        mockStatusCode = statusCode
        super.init(url: url, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MockTaskMaker {
    func makeTask(for urlPath: String, statusCode: Int, data: Data? = Data()) -> URLSessionDataTask {
        guard let url = URL(string: urlPath) else {
            XCTFail("The URL generated is not valid")
            return URLSessionDataTask()
        }
        
        let response = MockResponse(url: url, statusCode: statusCode)
        
        return MockTask(data: data, response: response, error: nil)
    }
}
