//
//  RxObserver.swift
//  ReSwiftBookmarker
//
//  Created by Jaewook on 09/11/2018.
//  Copyright © 2018 황재욱. All rights reserved.
//

import Foundation
import RxSwift
import ReSwift

class RxObserver<T>: StoreSubscriber {
    
    var subject = PublishSubject<T?>()
    var stateReactControl: Bool = false
    
    private var store: Store<AppState>
    
    init(store: Store<AppState>) {
        self.store = store
        self.store.subscribe(self) { subscription in
            subscription.select({ state in
                state
            }).skipRepeats({ [weak self] (a, b) -> Bool in
                return self?.stateReactControl ?? false
            })
        }
    }
    
    func unsubscribe() {
        self.store.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        self.subject.onNext(state.selectedState(input: T.self))
    }
}

// 특정 State을 선택해서 onNext 하기위한 프로퍼티 타입 순환 체크
// Mirror 사용
// 다른 방식으로 특정 타입 선택 방법 찾지 못함

extension AppState {
    func selectedState<T>(input: T.Type) -> T? {
        
        for (_, item) in Mirror(reflecting: self).children.enumerated() {
            if let correctItem = item.value as? T {
                return correctItem
            }
        }
        return nil
    }
}





