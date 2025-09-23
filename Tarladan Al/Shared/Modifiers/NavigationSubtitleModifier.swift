//
//  NavigationSubtitleModifier.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/22/25.
//
import SwiftUI

struct NavigationSubtitleModifier: ViewModifier {
    let subtitle: String?
    
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .navigationSubtitle(subtitle ?? "")
        } else {
            content
        }
      
    }
}
