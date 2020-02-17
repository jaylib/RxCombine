//
//  Subscription+Rx.swift
//  RxCombine
//
//  Created by Shai Mishali on 11/06/2019.
//  Copyright © 2019 Shai Mishali. All rights reserved.
//

import Combine
import RxSwift

/// A Combine Subscription wrapping a RxSwift Disposable.
/// Upon cancellation, the underlying Disposable is disposed of.
@available(iOS 13.0, tvOS 13.0, macOS 10.15, watchOS 6.0, *)
class RxSubscription: Subscription {
    private let disposable: Disposable

    init(disposable: Disposable) {
        self.disposable = disposable
    }

    func request(_ demand: Subscribers.Demand) {
        /// RxSwift doesn't have backpressure, so we ignore
        /// the consumer's demand
    }

    func cancel() {
        disposable.dispose()
    }
}
