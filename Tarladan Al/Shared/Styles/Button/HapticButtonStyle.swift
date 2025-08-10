//
//  HapticButtonStyle.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/10/25.
//

import SwiftUI

struct HapticButtonStyle: ButtonStyle {
    let style: UIImpactFeedbackGenerator.FeedbackStyle
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .onChange(of: configuration.isPressed) { pressed in
                if pressed {
                    let impactGenerator = UIImpactFeedbackGenerator(style: style)
                    impactGenerator.prepare()
                    impactGenerator.impactOccurred()
                }
            }
    }
}
