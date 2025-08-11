//
//  PersonalInfoView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//

import SwiftUI

struct PersonalInfoView: View {
    var body: some View {
        List {
            Section("Kişisel Bilgiler") {
                HStack {
                    Text("Ad Soyad")
                    Spacer()
                    Text("Semih Duran")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("E-posta")
                    Spacer()
                    Text("semih@example.com")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Telefon")
                    Spacer()
                    Text("+90 555 123 45 67")
                        .foregroundColor(.secondary)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Kişisel Bilgiler")
        .navigationBarTitleDisplayMode(.inline)
    }
}
