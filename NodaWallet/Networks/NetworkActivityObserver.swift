//
//  NetworkActivityObserver.swift

import UIKit
//network
public protocol NetworkActivityIndicatorOwner: class {
    var networkActivityIndicatorVisible: Bool { get set }
}

public let NetworkRequestDidBeginNotification = "NetworkRequestDidBeginNotification"
public let NetworkRequestDidEndNotification   = "NetworkRequestDidEndNotification"

final public class NetworkActivityObserver<T: NetworkActivityIndicatorOwner> {
    private var observers: [NSObjectProtocol] = []
    private let owner: T
    
    public init(networkActivityIndicatorOwner owner: T) {
        self.owner = owner
        startListening()
    }
    
    private func startListening() {
        assert(observers.isEmpty, "do not call startListening() multiple times")
        
        let notificationCenter = NotificationCenter.default
        
        observers.append(notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NetworkRequestDidBeginNotification), object: nil, queue: OperationQueue.main) { [weak self] _ in
            if let owner = self?.owner {
                updateApplicationSpinner(owner: owner, count: OSAtomicIncrement32(&count))
            }
        })
        
        observers.append(notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NetworkRequestDidEndNotification), object: nil, queue: OperationQueue.main) { [weak self] _ in
            if let owner = self?.owner {
                updateApplicationSpinner(owner: owner, count: OSAtomicDecrement32(&count))
            }
        })
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        for observer in observers {
            notificationCenter.removeObserver(observer)
        }
    }
    
}

private var count: Int32 = 0

private func updateApplicationSpinner<T: NetworkActivityIndicatorOwner>(owner: T, count: Int32) {
    precondition(count >= 0, "Incorrect NetworkActivityObserver increment/decrement pairing")
    owner.networkActivityIndicatorVisible = (count > 0)
}
