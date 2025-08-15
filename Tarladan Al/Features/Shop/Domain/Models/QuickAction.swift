//
//  QuickAction.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//

import Foundation
import SwiftUICore

struct QuickAction: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
}
