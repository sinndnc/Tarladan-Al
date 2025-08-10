//
//  Injected.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//


@propertyWrapper
struct Injected<T> {
    let wrappedValue: T
    
    init() {
        self.wrappedValue = DIContainer.shared.resolve(T.self)
    }
}