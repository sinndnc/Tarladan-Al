//
//  FarmerInfoCard.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/15/25.
//
import SwiftUI

struct FarmerInfoCardView: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Çiftçi Bilgileri")
                .font(.headline)
            
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text(product.farmerName)
                        .font(.subheadline)
                        .bold()
                    
                    Text(product.locationName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    // Telefon arama işlevi
                    if let phoneURL = URL(string: "tel:\(product.farmerPhone)") {
                        UIApplication.shared.open(phoneURL)
                    }
                }) {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.green)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
    }
}
