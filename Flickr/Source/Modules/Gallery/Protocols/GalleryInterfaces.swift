import UIKit

enum GalleryNavigationOption {
}

protocol GalleryWireframeInterface: WireframeInterface {
    func navigate(to option: GalleryNavigationOption)
}

protocol GalleryViewInterface: ViewInterface {
     var presenter: GalleryPresenterInterface! { get }
}

protocol GalleryPresenterInterface: PresenterInterface {
}

protocol GalleryDataInteractorInterface: InteractorInterface {
}
