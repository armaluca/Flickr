import UIKit

final class GalleryWireframe: BaseWireframe {

    // MARK: - Private properties
    private let storyboard: UIStoryboard = UIStoryboard(name: Constants.Storyboard.name, bundle: nil)

    // MARK: - Module setup
    func configureModule(with viewController: GalleryViewController) {
        let service = GalleryService()
        let dataInteractor = GalleryDataInteractor(service: service)
        let presenter = GalleryPresenter(wireframe: self, view: viewController, dataInteractor: dataInteractor)
        dataInteractor.delegate = presenter
        viewController.presenter = presenter
    }

    // MARK: - Transitions
    func show(with transition: Transition, animated: Bool = true) {
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController,
            let moduleViewController = navigationController.viewControllers.first as? GalleryViewController else {
            fatalError("Could not instantiate GalleryViewController!")
        }
        configureModule(with: moduleViewController)
        show(navigationController, with: transition, animated: animated)
    }
}

// MARK: - Extensions
extension GalleryWireframe: GalleryWireframeInterface {

    func navigate(to option: GalleryNavigationOption) {
    }
}

// MARK: - Constants
extension GalleryWireframe {
    struct Constants {
        struct Storyboard {
            static let name = "Gallery"
        }
    }
}
