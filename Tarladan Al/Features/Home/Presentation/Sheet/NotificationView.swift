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
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NotificationView()
}
