//
//  NotificationView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//

import SwiftUI

struct NotificationSettingView: View {
    
    var body : some View{
        Text("Notification Setting View")
        .toolbarTitleDisplayMode(.inline)
        .background(Colors.System.background)
        .toolbarColorScheme(.dark, for:.navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Colors.UI.tabBackground, for: .navigationBar)
        
    }
    
}
