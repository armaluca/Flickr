import Foundation

final class GalleryDataInteractor: GalleryDataInteractorInterface {
    
    weak var delegate: DataInteractorDelegateInterface?
    private let service: GalleryNetworkingServiceInterface
    
    init(service: GalleryNetworkingServiceInterface) {
        self.service = service
    }
    
    func fetchModels() {
        service.loadFeed { [weak self] (error, data) in
            if let error = error {
                self?.delegate?.dataInteractorDidFinishFetchWithFailure(error: error)
                return
            }
            
            self?.delegate?.dataInteractorDidFinishFetch(model: data)
        }
    }
}
