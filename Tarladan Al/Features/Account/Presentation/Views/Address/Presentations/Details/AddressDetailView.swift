//
//  AddressDetailView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/21/25.
//
import SwiftUI

struct AddressDetailView: View {
    let address: Address
    @State private var showingEditView = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20){
                VStack(alignment: .leading, spacing: 20){
                    AddressInfoRow(title: "Adres Başlığı", value: address.title, icon: "tag.fill")
                    
                    AddressInfoRow(title: "Tam Adres", value: address.fullAddress, icon: "location.fill")
                    
                    AddressInfoRow(title: "İlçe", value: address.district, icon: "building.2.fill")
                    
                    AddressInfoRow(title: "Şehir", value: address.city, icon: "building.fill")
                }
                .padding(.vertical)
                
                
                Button(action: {
                    showingEditView = true
                }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Adresi Düzenle")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button(action: {
                    openInMaps()
                }) {
                    HStack {
                        Image(systemName: "map")
                        Text("Harita'da Göster")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                if !address.isDefault {
                    Button(action: {
                        // Varsayılan yap fonksiyonu
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Varsayılan Yap")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Adres Detayı")
        .toolbarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            Text("Adres Düzenleme Ekranı")
                .navigationTitle("Adresi Düzenle")
        }
    }
    
    private func openInMaps() {
        let addressString = "\(address.fullAddress), \(address.district), \(address.city)"
        let encodedAddress = addressString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "http://maps.apple.com/?q=\(encodedAddress)"
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
