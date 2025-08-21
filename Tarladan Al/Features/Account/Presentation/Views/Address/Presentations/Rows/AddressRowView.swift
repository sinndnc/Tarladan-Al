//
//  AddressRowView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/21/25.
//
import SwiftUI

struct AddressRowView: View {
    let address: Address
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(address.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if address.isDefault {
                        Text("Varsayılan")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(4)
                    }
                    
                    Spacer()
                }
                
                Text(address.fullAddress)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack {
                    Text(address.district)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(address.city)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
