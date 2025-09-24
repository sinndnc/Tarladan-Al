//
//  QuickActionCard.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//
import SwiftUI

struct QuickActionCard: View {
    let quickAction: QuickAction
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: quickAction.icon)
                .font(.system(size: 24))
                .foregroundColor(quickAction.color)
                .frame(width: 50, height: 50)
                .background(quickAction.color.opacity(0.15))
                .clipShape(Circle())
            
            VStack(spacing: 4) {
                Text(quickAction.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(quickAction.subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 120)
        .padding(.vertical, 15)
        .background(Colors.System.surface)
        .cornerRadius(16)
    }
    
}
