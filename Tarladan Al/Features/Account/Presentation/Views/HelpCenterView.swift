//
//  HelpCenterView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//
import SwiftUI

struct HelpCenterView: View {
    var body: some View {
        List {
            Section("Sık Sorulan Sorular") {
                Text("Siparişim ne zaman gelir?")
                Text("İptal işlemi nasıl yapılır?")
                Text("Ödeme seçenekleri nelerdir?")
            }
            
            Section("Diğer") {
                Text("Kullanım Koşulları")
                Text("Gizlilik Politikası")
                Text("İletişim")
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Yardım Merkezi")
        .navigationBarTitleDisplayMode(.inline)
    }
}
