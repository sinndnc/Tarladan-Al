//
//  LocationPickerView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/10/25.
//

import SwiftUI

struct LocationPickerView: View {
    
    let addresses: [Address]
    
    var body: some View {
        NavigationStack{
            VStack(alignment:.leading){
                Text("Siparişinizi nereye göndermek istediğinizi seçiniz.")
                    .font(.headline)
                Divider()
                Spacer()
                VStack(alignment:.leading,spacing: 20){
                    ForEach(addresses.sortedByDefault) { address in
                        LocationPickerRow(address: address)
                    }
                }
                Spacer()
                Button {
                    
                } label: {
                    AddNewLocationRow()
                }
                .haptic()
            }
            .padding()
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
                    .font(.footnote)
                    .foregroundStyle(.gray)
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
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "pencil.circle")
                    .fontWeight(.medium)
            }
        }
    }
}
