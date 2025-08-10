//
//  HapticModifier.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/10/25.
//
import SwiftUI

struct HapticModifier: ViewModifier {
    let style: UIImpactFeedbackGenerator.FeedbackStyle
    let action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        let impactGenerator = UIImpactFeedbackGenerator(style: style)
                        impactGenerator.prepare()
                        impactGenerator.impactOccurred()
                        action?()
                    }
            )
    }
}
