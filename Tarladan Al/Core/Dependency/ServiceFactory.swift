//
//  ServiceFactory.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation

struct ServiceFactory {
    let scope: ServiceScope
    let factory: (DIContainer) -> Any
}
