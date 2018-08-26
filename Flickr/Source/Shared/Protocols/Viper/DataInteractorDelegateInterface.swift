import Foundation

protocol DataInteractorDelegateInterface: class {
    func dataInteractorWillFetch()
    func dataInteractorDidFinishFetch(model: Any?)
    func dataInteractorDidFinishFetchWithFailure(error: Error)
}

extension DataInteractorDelegateInterface {
    func dataInteractorWillFetch() {}
}
