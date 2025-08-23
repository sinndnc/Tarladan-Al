//
//  CategoryChip.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/18/25.
//
import SwiftUI

struct CategoryChip: View {
    let title: String
    let count: Int
    let isSelected: Bool
    var showZeroCount: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if showZeroCount || count > 0 {
                    Text("(\(count))")
                        .font(.caption)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.blue : Color(.systemGray6))
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
