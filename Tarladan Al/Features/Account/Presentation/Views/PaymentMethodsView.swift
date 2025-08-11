//
//  PaymentMethodsView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//

import SwiftUI

struct PaymentMethodsView: View {
    var body: some View {
        List {
            Section("Kayıtlı Kartlarım") {
                HStack {
                    Image(systemName: "creditcard.fill")
                        .foregroundColor(.blue)
                    VStack(alignment: .leading) {
                        Text("**** **** **** 1234")
                            .font(.headline)
                        Text("Visa")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Ödeme Yöntemleri")
        .navigationBarTitleDisplayMode(.inline)
    }
}
