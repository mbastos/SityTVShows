//
//  ObservableQueue.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import Foundation
import RxSwift

class ObservableQueue {

    private let semaphore = DispatchSemaphore(value: 1)
    private let scheduler = ConcurrentDispatchQueueScheduler(qos: .userInitiated)

    func enqueue<T>(_ observable: Observable<T>) -> Observable<T> {
        let _semaphore = semaphore
        return Observable.create { observer in
            _semaphore.wait()
            let disposable = observable.subscribe { event in
                observer.on(event)
            }
            return Disposables.create {
                disposable.dispose()
                _semaphore.signal()
            }
        }
        .subscribe(on: scheduler)
    }
}
