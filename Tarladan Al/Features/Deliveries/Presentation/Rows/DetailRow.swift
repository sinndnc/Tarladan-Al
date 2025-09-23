//
//  DetailRow.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/23/25.
//
import SwiftUI

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}
