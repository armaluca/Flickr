import UIKit

typealias NetworkingCompletion = (Error?, Any?) -> Void

enum GalleryNavigationOption {
}

protocol GalleryWireframeInterface: WireframeInterface {
    func navigate(to option: GalleryNavigationOption)
}

protocol GalleryViewInterface: ViewInterface {
    var presenter: GalleryPresenterInterface! { get }
    func reload()
    func showErrorState(for error: Error)
}

protocol GalleryPresenterInterface: PresenterInterface {
    var items: [FlickrPhoto]? { get }
    func load()
}

protocol GalleryDataInteractorInterface: InteractorInterface {
    func fetchModels()
}

protocol GalleryNetworkingServiceInterface {
    func loadFeed(completion: @escaping NetworkingCompletion)
}
