//
//  Subject+Rx.swift
//  RxCombine
//
//  Created by Shai Mishali on 11/06/2019.
//  Copyright © 2019 Shai Mishali. All rights reserved.
//

import Combine
import RxSwift
import RxRelay

/// Represents a Combine Subject that can be converted
/// to a RxSwift AnyObserver of the underlying Output type.
///
/// - note: This only works when the underlying Failure is Swift.Error,
///         since RxSwift has no typed errors.
@available(iOS 13.0, tvOS 13.0, macOS 10.15, watchOS 6.0, *)
public protocol AnyObserverConvertible: Combine.Subject where Failure == Swift.Error {
    associatedtype Output

    /// Returns a RxSwift AnyObserver wrapping the Subject
    ///
    /// - returns: AnyObserver<Output>
    func asAnyObserver() -> AnyObserver<Output>
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15, watchOS 6.0, *)
public extension AnyObserverConvertible {
    /// Returns a RxSwift AnyObserver wrapping the Subject
    ///
    /// - returns: AnyObserver<Output>
    func asAnyObserver() -> AnyObserver<Output> {
        AnyObserver { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .next(let value):
                self.send(value)
            case .error(let error):
                self.send(completion: .failure(error))
            case .completed:
                self.send(completion: .finished)
            }
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15, watchOS 6.0, *)
extension PassthroughSubject: AnyObserverConvertible where Failure == Swift.Error {}

@available(iOS 13.0, tvOS 13.0, macOS 10.15, watchOS 6.0, *)
extension CurrentValueSubject: AnyObserverConvertible where Failure == Swift.Error {}

@available(iOS 13.0, tvOS 13.0, macOS 10.15, watchOS 6.0, *)
public extension ObservableType {
    /**
     Creates new subscription and sends elements to a Combine Subject.

     - parameter to: Combine subject to receives events.
     - returns: Disposable object that can be used to unsubscribe the observers.
     - seealso: `AnyOserverConvertible`
     */
    func bind<S: AnyObserverConvertible>(to subject: S) -> Disposable where S.Output == Element {
        subscribe(subject.asAnyObserver())
    }
}
