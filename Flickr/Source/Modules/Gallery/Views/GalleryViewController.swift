import UIKit

final class GalleryViewController: UIViewController {
    var presenter: GalleryPresenterInterface!
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
	
}

// MARK: - Extensions
extension GalleryViewController: GalleryViewInterface {
    func reload() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    func showErrorState(for error: Error) {
    }
}
