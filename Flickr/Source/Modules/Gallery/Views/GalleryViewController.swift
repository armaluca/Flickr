import UIKit

final class GalleryViewController: UIViewController {
    var presenter: GalleryPresenterInterface!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var stateView: GalleryStateView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        stateView.prepare(for: .empty)
        presenter.viewDidLoad()
    }
}

// MARK: - GalleryViewInterface
extension GalleryViewController: GalleryViewInterface {
    func reload() {
        DispatchQueue.main.async { [weak self] in
            self?.stateView.isHidden = true
            self?.tableView.reloadData()
        }
    }
    
    func showErrorState(for error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.stateView.prepare(for: .error) { [weak self] in
                self?.presenter.viewDidLoad()
            }
            self?.stateView.isHidden = false
        }
        print(error.localizedDescription)
    }
}
