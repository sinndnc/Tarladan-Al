//
//  MenuSection.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/25/25.
//
import SwiftUI

struct MenuSection: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let icon: String
    let items: [SubMenuItem]
}
