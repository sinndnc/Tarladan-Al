//
//  LocationPickerView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/10/25.
//

import SwiftUI

struct LocationPickerView: View {
    
    let addresses: [Address]
    @EnvironmentObject private var userViewModel: UserViewModel
    
    var body: some View {
        NavigationStack{
            VStack(alignment:.leading,spacing: 0){
                HStack{
                    Text("Siparişinizi nereye göndermek istediğinizi seçiniz.")
                        .font(.headline)
                    Spacer()
                }
                .padding()
                
                Divider()
                
                Spacer()
                
                VStack(alignment:.leading,spacing: 20){
                    ForEach(addresses.sortedByDefault) { address in
                        Button {
                            userViewModel.updateDefaultAddress(address)
                        } label: {
                            LocationPickerRow(address: address)
                        }
                        .haptic()
                        .tint(.primary)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                NavigationLink{
                    NewAddressFormView()
                } label: {
                    AddNewLocationRow()
                }
                .haptic()
                .padding(.horizontal)
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.fraction(0.3)])
        }
       
    }
}

struct AddNewLocationRow : View{
    
    var body: some View {
        HStack{
            Image(systemName: "plus")
                .font(.title2)
                .fontWeight(.medium)
            Text("Yeni Adres Ekle")
        }
    }
}

struct LocationPickerRow : View{
    
    let address : Address
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(address.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(address.fullAddress)
                    .lineLimit(2)
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            if address.isDefault{
               Text("Varsayılan")
                    .padding(5)
                    .font(.caption)
                    .background(.blue.opacity(0.2))
                    .foregroundStyle(.blue)
                    .cornerRadius(8)
            }
            
            Button {
                
            } label: {
                Image(systemName: "pencil.circle")
                    .fontWeight(.medium)
            }
        }
    }
}
