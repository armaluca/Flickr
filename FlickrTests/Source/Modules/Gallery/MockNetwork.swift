import XCTest

// MARK: - URLSession Mock
class MockURLSession: URLSession {
    
    // MARK: Properties
    var mockedTasks: [URLSessionDataTask]?
    
    // MARK: Public
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        return findMockTask(for: url, completion: completionHandler)
    }

    override func dataTask(with url: URL) -> URLSessionDataTask {
        
        return findMockTask(for: url, completion: nil)
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        return findMockTask(for: request.url, completion: completionHandler)
    }
    
    // MARK: Private
    private func findMockTask(for url: URL?, completion: ((Data?, URLResponse?, Error?) -> Void)?) -> URLSessionDataTask { //swiftlint:disable:this large_tuple
        
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

// MARK: - URLSessionDataTask Mock
class MockTask: URLSessionDataTask {
    
    // MARK: Properties
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)? //swiftlint:disable:this large_tuple
    public var isResumeCalled = false
    public var isCanceledCalled = false
    
    private var _data: Data?
    private var _error: Error?
    private var _response: URLResponse?
    
    override var response: URLResponse? {
        return _response
    }
    
    // MARK: Init
    init(data: Data?, response: URLResponse?, error: Error?) {
        
        _data = data
        _error = error
        _response = response
        
    }
    
    // MARK: Public
    override func resume() {
        
        isResumeCalled = true
        completionHandler?(_data, _response, _error)
    }
    
    override func cancel() {
        isCanceledCalled = true
    }
    
}

// MARK: - HTTPURLResponse Mock
class MockResponse: HTTPURLResponse {
    
    // MARK: Properties
    private var _statusCode: Int = 404
    
    override var statusCode: Int {
        return _statusCode
    }
    
    // MARK: Init
    init(url: URL, statusCode: Int) {
        _statusCode = statusCode
        super.init(url: url, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - TaskMaker
class MockTaskMaker {
    // MARK: Public
    public func makeImageDownloadTasks(for urlPaths: [(path: String, valid: Bool)]) -> [URLSessionDataTask] {
        
        var tasks = [URLSessionDataTask]()
        
        for tuple in urlPaths {
            tasks.append(makeImageDownloadTask(for: tuple.path, validData: tuple.valid))
        }
        
        return tasks
    }
    
    public func makeValidImageDownloadTasks(for urlPaths: [String]) -> [URLSessionDataTask] {
        
        var tasks = [URLSessionDataTask]()
        
        for path in urlPaths {
            tasks.append(makeImageDownloadTask(for: path, validData: true))
        }
        
        return tasks
    }
    
    public func makeImageDownloadTask(for urlPath: String, validData: Bool, statusCode: Int = 200, error: Error? = nil) -> URLSessionDataTask {
        
        let mockImageName = "back_icon"
        
        guard let url = URL(string: urlPath),
            let image = UIImage(named: mockImageName) else {
                XCTFail("The URL or image generated are not valid")
                return URLSessionDataTask()
        }
        
        if validData {
            
            let data = UIImagePNGRepresentation(image)
            let response = MockResponse(url: url, statusCode: statusCode)
            return MockTask(data: data, response: response, error: error)
            
        } else {
            
            let response = MockResponse(url: url, statusCode: statusCode)
            let notValidData = Data()
            return MockTask(data: notValidData, response: response, error: error)
            
        }
        
    }
    
    public func makeTask(for urlPath: String, statusCode: Int) -> URLSessionDataTask {
        
        guard let url = URL(string: urlPath) else {
            
            XCTFail("The URL generated is not valid")
            return URLSessionDataTask()
        }
        
        let response = MockResponse(url: url, statusCode: statusCode)
        
        return MockTask(data: Data(), response: response, error: nil)
        
    }
    
}
