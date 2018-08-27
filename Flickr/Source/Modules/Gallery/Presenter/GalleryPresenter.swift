import UIKit

final class GalleryPresenter {
    var items: [FlickrPhoto]?
    
    fileprivate weak var view: GalleryViewInterface?
    fileprivate var dataInteractor: GalleryDataInteractorInterface
    fileprivate var wireframe: GalleryWireframeInterface

    // MARK: - Lifecycle
    init(wireframe: GalleryWireframeInterface, view: GalleryViewInterface, dataInteractor: GalleryDataInteractorInterface) {
        self.wireframe = wireframe
        self.view = view
        self.dataInteractor = dataInteractor
    }
    
    func viewDidLoad() {
        load()
    }
    
    func load() {
        dataInteractor.fetchModels()
    }
}

// MARK: - GalleryPresenterInterface
extension GalleryPresenter: GalleryPresenterInterface {}

// MARK: - DataInteractorDelegateInterface
extension GalleryPresenter: DataInteractorDelegateInterface {
    func dataInteractorDidFinishFetch(model: Any?) {
        guard let flickrPhotos = model as? [FlickrPhoto] else {
            return
        }
        
        items = flickrPhotos
        view?.reload()
    }
    
    func dataInteractorDidFinishFetchWithFailure(error: Error) {
        view?.showErrorState(for: error)
    }
}
