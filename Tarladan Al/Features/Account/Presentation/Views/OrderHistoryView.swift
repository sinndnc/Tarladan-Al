//
//  OrderHistoryView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//
import SwiftUI

struct OrderHistoryView: View {
    var body: some View {
        List {
            Section("Son Siparişlerim") {
                ForEach(0..<5) { index in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Sipariş #\(1000 + index)")
                                .font(.headline)
                            Spacer()
                            Text("Teslim Edildi")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.green)
                                .cornerRadius(4)
                        }
                        Text("3 ürün • ₺\((index + 1) * 50)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Sipariş Geçmişi")
        .navigationBarTitleDisplayMode(.inline)
    }
}
