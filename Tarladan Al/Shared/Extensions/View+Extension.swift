//
//  View+Extension.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/10/25.
//

import SwiftUI
import UIKit

extension View {
    /// Normal view'lar için haptic
    func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.modifier(HapticModifier(style: style, action: nil))
    }
    
    /// Button'lar için haptic - action ile birlikte
    func hapticAction(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium, action: @escaping () -> Void) -> some View {
        self.modifier(HapticModifier(style: style, action: action))
    }
    
    func withHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.buttonStyle(HapticButtonStyle(style: style))
    }
}
