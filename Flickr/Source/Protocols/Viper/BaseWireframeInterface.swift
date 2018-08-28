import UIKit

enum Transition {
    case root
    case push
    case present(fromViewController: UIViewController)
}

protocol WireframeInterface: class {
    func popFromNavigationController(animated: Bool)
    func dismiss(animated: Bool)
}

class BaseWireframe {
    
    weak var navigationController: UINavigationController?
    weak var rootViewController: UIViewController?
    weak var window: UIWindow?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func show(_ viewController: UIViewController, with transition: Transition, animated: Bool) {
        
        switch transition {
        case .push:
            navigationController?.pushViewController(viewController, animated: animated)
            
        case .present(let fromViewController):
            if let navigationController = viewController as? UINavigationController {
                self.navigationController = navigationController
            } else {
                rootViewController = viewController
            }
            
            fromViewController.present(viewController, animated: animated, completion: nil)
            
        case .root:
            if let window = window {
                
                if let viewController = viewController as? UINavigationController {
                    navigationController = viewController
                }
                
                rootViewController = viewController

                window.rootViewController = rootViewController
                window.makeKeyAndVisible()
            } else {
                fatalError("Failed to add the viewController to the root!")
            }
        }
    }
}

extension BaseWireframe: WireframeInterface {
    
    func popFromNavigationController(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    func dismiss(animated: Bool) {
        
        guard let navigationController = navigationController else {
            rootViewController?.dismiss(animated: animated)
            return
        }
        
        navigationController.dismiss(animated: animated)
    }
}
