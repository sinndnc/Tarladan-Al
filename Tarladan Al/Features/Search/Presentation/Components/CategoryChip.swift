//
//  CategoryChip.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/15/25.
//
import SwiftUI

struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let count: Int
    
    var body: some View {
        HStack(spacing: 6) {
            if icon.count == 1 {
                Text(icon)
                    .font(.caption)
            } else {
                Image(systemName: icon)
                    .font(.caption2)
            }
            
            Text(title)
                .font(.caption)
                .bold(isSelected)
                .fontWeight(.medium)
            
            if count > 0 {
                Text("(\(count))")
                    .font(.caption2)
                    .bold(isSelected)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(isSelected ? Color.blue : Color.gray.opacity(0.1))
        )
        .foregroundColor(isSelected ? .white : .primary)
    }
}
