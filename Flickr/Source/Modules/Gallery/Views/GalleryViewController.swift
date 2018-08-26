import UIKit

final class GalleryViewController: UIViewController {

    // MARK: - Public properties
    var presenter: GalleryPresenterInterface!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
	
}

// MARK: - Extensions
extension GalleryViewController: GalleryViewInterface {
}
