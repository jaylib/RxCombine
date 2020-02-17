//
//  Subjects+Combine.swift
//  RxCombine
//
//  Created by Shai Mishali on 11/06/2019.
//  Copyright © 2019 Shai Mishali. All rights reserved.
//

import Combine
import RxSwift

// MARK: - Behavior Subject as Combine Subject
@available(iOS 13.0, tvOS 13.0, macOS 10.15, watchOS 6.0, *)
extension BehaviorSubject: Combine.Subject {
    public func receive<S: Subscriber>(subscriber: S) where BehaviorSubject.Failure == S.Failure,
                                                            BehaviorSubject.Output == S.Input {
        _ = subscribe(subscriber.pushRxEvent)
    }

    public func send(_ value: BehaviorSubject<Element>.Output) {
        onNext(value)
    }

    public func send(completion: Subscribers.Completion<BehaviorSubject<Element>.Failure>) {
        switch completion {
        case .finished:
            onCompleted()
        case .failure(let error):
            onError(error)
        }
    }

    public func send(subscription: Subscription) {
        /// no-op: Relays don't have anything to do with a Combine subscription
    }

    public typealias Output = Element
    public typealias Failure = Swift.Error
}

// MARK: - Publish Subject as Combine Subject
@available(iOS 13.0, tvOS 13.0, macOS 10.15, watchOS 6.0, *)
extension PublishSubject: Combine.Subject {
    public func receive<S: Subscriber>(subscriber: S) where PublishSubject.Failure == S.Failure,
                                                            PublishSubject.Output == S.Input {
        _ = subscribe(subscriber.pushRxEvent)
    }

    public func send(_ value: PublishSubject<Element>.Output) {
        onNext(value)
    }

    public func send(completion: Subscribers.Completion<PublishSubject<Element>.Failure>) {
        switch completion {
        case .finished:
            onCompleted()
        case .failure(let error):
            onError(error)
        }
    }

    public func send(subscription: Subscription) {
        /// no-op: Relays don't have anything to do with a Combine subscription
    }

    public typealias Output = Element
    public typealias Failure = Swift.Error
}
