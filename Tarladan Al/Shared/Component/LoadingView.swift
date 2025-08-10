//
//  LoadingView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//
import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                Text("Yükleniyor...")
                    .font(.system(size: 16, weight: .medium))
            }
            .padding(24)
            .background(Color(.systemBackground))
            .cornerRadius(16)
        }
    }
}
