//
//  Subscriber+Rx.swift
//  RxCombine
//
//  Created by Shai Mishali on 11/06/2019.
//  Copyright © 2019 Shai Mishali. All rights reserved.
//

import Combine
import RxSwift

@available(iOS 13.0, tvOS 13.0, macOS 10.15, watchOS 6.0, *)
extension Subscriber where Failure == Never {
    /// Push a provided RxSwift.event onto the Combine Subscriber.
    ///
    /// - parameter event: RxSwift Event to push onto the Combine Subscriber.
    func pushRxEvent(_ event: RxSwift.Event<Input>) {
        switch event {
        case .next(let element):
            _ = receive(element)
        case .error:
            fatalError("Failure is not an option")
        case .completed:
            receive(completion: .finished)
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15, watchOS 6.0, *)
extension Subscriber where Failure == Swift.Error {
    /// Push a provided RxSwift.event onto the Combine Subscriber.
    ///
    /// - parameter event: RxSwift Event to push onto the Combine Subscriber.
    func pushRxEvent(_ event: RxSwift.Event<Input>) {
        switch event {
        case .next(let element):
            _ = receive(element)
        case .error(let error):
            receive(completion: .failure(error))
        case .completed:
            receive(completion: .finished)
        }
    }
}
