//
//  AddressFormView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/18/25.
//
import SwiftUI

struct NewAddressFormView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var fullAddress = ""
    @State private var city = ""
    @State private var district = ""
    @State private var isDefault = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Adres Bilgileri") {
                    TextField("Adres Başlığı (Ev, İş, vb.)", text: $title)
                    TextField("Tam Adres", text: $fullAddress, axis: .vertical)
                        .lineLimit(3...6)
                    TextField("Şehir", text: $city)
                    TextField("İlçe", text: $district)
                    
                    Toggle("Varsayılan adres yap", isOn: $isDefault)
                }
            }
            .navigationTitle("Yeni Adres")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Kaydet") {
                    // Adres kaydetme işlemi
                    dismiss()
                }
                .disabled(title.isEmpty || fullAddress.isEmpty || city.isEmpty || district.isEmpty)
            )
        }
    }
}
