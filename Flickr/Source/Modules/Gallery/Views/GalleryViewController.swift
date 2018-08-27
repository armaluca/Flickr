import UIKit

final class GalleryViewController: UIViewController {
    var presenter: GalleryPresenterInterface!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var stateView: GalleryStateView!
    
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(didPullToRefresh),
                                 for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.addSubview(refreshControl)
        stateView.prepare(for: .empty) { [weak self] in
            self?.presenter.load()
        }
    }
    
    @objc func didPullToRefresh() {
        presenter.load()
        refreshControl.endRefreshing()
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
                self?.presenter.load()
            }
            self?.stateView.isHidden = false
        }
        print(error.localizedDescription)
    }
}
