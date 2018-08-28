import UIKit

protocol ExternalObjectViewInterfaceType {
    
    associatedtype ViewControllerType: UIViewController, ViewInterface
    
    var viewController: ViewControllerType! { get set }
}

