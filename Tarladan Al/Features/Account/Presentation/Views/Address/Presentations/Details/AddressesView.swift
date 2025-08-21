//
//  AddressesView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//
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
                    ForEach(user.addresses.sortedByDefault) { address in
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
