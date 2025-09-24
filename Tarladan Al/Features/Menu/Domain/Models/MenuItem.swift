//
//  MenuItem.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/25/25.
//
import SwiftUI

struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let icon: String
    let subItems: [SubMenuItem]
    let category: MenuCategory
}
