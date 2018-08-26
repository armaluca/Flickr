import UIKit

final class GalleryPresenter {

    // MARK: - Private properties
    fileprivate weak var view: GalleryViewInterface?
    fileprivate var dataInteractor: GalleryDataInteractorInterface
    fileprivate var wireframe: GalleryWireframeInterface

    // MARK: - Lifecycle
    init(wireframe: GalleryWireframeInterface, view: GalleryViewInterface, dataInteractor: GalleryDataInteractorInterface) {
        self.wireframe = wireframe
        self.view = view
        self.dataInteractor = dataInteractor
    }
}

// MARK: - Extensions
extension GalleryPresenter: GalleryPresenterInterface {}

extension GalleryPresenter: DataInteractorDelegateInterface {
    
    func dataInteractorDidFinishFetch(model: Any?) {}
    func dataInteractorDidFinishFetchWithFailure(error: Error) {}
    
}
