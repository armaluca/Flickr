import Foundation

final class GalleryDataInteractor: GalleryDataInteractorInterface {
    
    weak var delegate: DataInteractorDelegateInterface?
    private let service: GalleryService
    
    init(service: GalleryService) {
        self.service = service
    }
    
    func fetchModels() {
        service.loadFeed { (error, data) in
            if let error = error {
                delegate?.dataInteractorDidFinishFetchWithFailure(error: error)
                return
            }
            
            delegate?.dataInteractorDidFinishFetch(model: data)
        }
    }
}
