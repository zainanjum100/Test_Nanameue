//
//  Dynamic.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 21/06/2022.
//

import Foundation
// Observer class for obserable MVVM
// We can bind the variables and refresh data according to listners
final class Observer<T> {
    typealias Listener = (T) -> Void
  
    var listener: Listener? = nil
    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
