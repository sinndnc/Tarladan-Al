//
//  ReviewsView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//
import SwiftUI

struct ReviewsView: View {
    var body: some View {
        List {
            Section("Değerlendirmelerim") {
                ForEach(0..<3) { index in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Organik Elma")
                            .font(.headline)
                        
                        HStack {
                            ForEach(0..<5) { star in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                            }
                            Text("5.0")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Çok taze ve lezzetliydi, kesinlikle tavsiye ederim!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Değerlendirmelerim")
        .navigationBarTitleDisplayMode(.inline)
    }
}
