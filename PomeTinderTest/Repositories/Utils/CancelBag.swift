//
//  CancelBag.swift
//  PomeTinderTest
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 10/10/2024.
//

import Foundation
import Combine

class CancelBag {
    fileprivate(set) var subscriptions = Set<AnyCancellable>()
    
    public init() { }
    
   public func cancel() {
        subscriptions.removeAll()
    }
    
   public func collect(@Builder _ cancellables: () -> [AnyCancellable]) {
        subscriptions.formUnion(cancellables())
    }
}

@resultBuilder struct Builder {
   public static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
        return cancellables
    }
}

extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
