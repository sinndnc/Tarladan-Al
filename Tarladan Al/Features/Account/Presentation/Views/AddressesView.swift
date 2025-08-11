//
//  AddressesView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//
import SwiftUI

struct AddressesView: View {
    var body: some View {
        List {
            Section("Kayıtlı Adreslerim") {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ev Adresi")
                        .font(.headline)
                    Text("Mimar Sinan Mah. Atatürk Cad. No:123")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("İş Adresi")
                        .font(.headline)
                    Text("Osmangazi Mah. İnönü Bulvarı No:456")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Adreslerim")
        .navigationBarTitleDisplayMode(.inline)
    }
}
