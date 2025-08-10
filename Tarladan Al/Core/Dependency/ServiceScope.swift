//
//  ServiceScope.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation

enum ServiceScope {
    case singleton
    case transient
    case scoped(String)
}
