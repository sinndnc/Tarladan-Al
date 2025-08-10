//
//  Category.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation
import SwiftUICore

struct Category: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let displayName: String
    let description: String
    let icon: String
    let color: Color
    let productCount: Int
    let isNew: Bool
    let isSeasonal: Bool
    let bannerImage: String?
}

