import Foundation

protocol DataInteractorInterface: InteractorInterface {
    var delegate: DataInteractorDelegateInterface? { get set }
}
