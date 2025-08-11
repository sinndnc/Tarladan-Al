//
//  ContactSupportView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//
import SwiftUI

struct ContactSupportView: View {
    var body: some View {
        List {
            Section("İletişim Bilgileri") {
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.green)
                    Text("0850 123 45 67")
                }
                
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.blue)
                    Text("destek@example.com")
                }
                
                HStack {
                    Image(systemName: "message.fill")
                        .foregroundColor(.purple)
                    Text("WhatsApp Destek")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Bize Ulaşın")
        .navigationBarTitleDisplayMode(.inline)
    }
}
