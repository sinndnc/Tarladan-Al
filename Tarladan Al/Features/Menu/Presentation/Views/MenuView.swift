//
//  MenuView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/22/25.
//

import SwiftUI

struct MenuView: View {
    
    @EnvironmentObject private var menuViewModel : MenuViewModel
    
    var body: some View {
        NavigationStack{
            List {
                Section(header: Text("Maddi İşlemler")){
                    Text("Krediler")
                    Text("Sigortalar")
                    Text("Teminantlar")
                }
                
                Section(header: Text("Çiftçi İşlemler")){
                    Text("Stok Güncelleme")
                    Text("Hasat Bildirimi")
                    Text("Tedarik Sözleşmeleri")
                }
                
                Section(header: Text("Giriş Seçenekleri")){
                    Text("HKS sistemine geçiş")
                    Text("E-Arşiv sistemine geçiş")
                    Text("E-Devlet sistemine geçiş")
                }
                
                Section(header: Text("Kalite ve Sertifikasyon")){
                    Text("Organik sertifikaları")
                    Text("Laboratuvar test sonuçları")
                }
            }
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
            .navigationSubtitleCompat("Tüm işlemler bir kaç tık uzağında!")
        }
    }
}

#Preview {
    MenuView()
}
