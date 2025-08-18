//
//  AddressesView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//
import SwiftUI

import SwiftUI

struct AddressesView: View {
    
    
    @State private var showingAddAddress = false
    @EnvironmentObject private var userViewModel : UserViewModel
    
    var body: some View {
        List {
            if let user = userViewModel.user{
                if user.addresses.isEmpty {
                    Text("No Addresses Found")
                }else{
                    ForEach(user.addresses) { address in
                        NavigationLink(destination: AddressDetailView(address: address)) {
                            AddressRowView(address: address)
                        }
                    }
                    .onDelete(perform: deleteAddresses)
                }
            }
        }
        .navigationTitle("Adreslerim")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddAddress = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddAddress) {
            NewAddressFormView()
        }
    }
    
    func deleteAddresses(offsets: IndexSet) {
        if var user = userViewModel.user{
            user.addresses.remove(atOffsets: offsets)
        }
    }
}

// MARK: - Address Row View
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

// MARK: - Address Detail View
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
        .navigationBarTitleDisplayMode(.inline)
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

// MARK: - Address Info Row Component
struct AddressInfoRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 20)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            Text(value)
                .font(.body)
                .padding(.leading, 28)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - Preview
struct AddressesView_Previews: PreviewProvider {
    static var previews: some View {
        AddressesView()
    }
}

struct AddressDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddressDetailView(address: Address(
                title: "Ev",
                fullAddress: "Atatürk Caddesi No: 123/4",
                city: "İstanbul",
                district: "Kadıköy",
                isDefault: true
            ))
        }
    }
}
