//
//  NotificationView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/13/25.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        VStack{
            Text("Hello, World!")
        }
        .toolbarRole(.editor)
        .navigationTitle("Bildirimler")
        .background(Colors.System.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        .toolbarBackground(Colors.UI.tabBackground, for: .navigationBar)
    }
}

#Preview {
    NotificationView()
}
