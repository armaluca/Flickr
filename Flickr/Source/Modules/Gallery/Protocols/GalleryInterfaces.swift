import UIKit

typealias NetworkingCompletion = (NetworkingError?, Any?) -> Void

enum NetworkingError: Error {
    case failed(message: String)
}

enum GalleryNavigationOption {
}

protocol GalleryWireframeInterface: WireframeInterface {
    func navigate(to option: GalleryNavigationOption)
}

protocol GalleryViewInterface: ViewInterface {
     var presenter: GalleryPresenterInterface! { get }
}

protocol GalleryPresenterInterface: PresenterInterface {
    var items: [FlickrPhoto]? { get }
}

protocol GalleryDataInteractorInterface: InteractorInterface {
    func fetchModels()
}

protocol GalleryNetworkingService {
    func loadFeed(completion: NetworkingCompletion)
}
