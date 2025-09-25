//
//  MenuView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/22/25.
//
import SwiftUI

struct MenuView: View {
    
    @EnvironmentObject private var  menuViewModel : MenuViewModel
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(menuViewModel.menuItems, id: \.self) { section in
                    Section {
                        ForEach(section.items, id: \.self) { item in
                            MenuRowView(menuItem: item)
                        }
                    } header: {
                        Text(section.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
            }
            .navigationTitle("İşlemler")
            .navigationBarTitleDisplayMode(.inline)
            .navigationSubtitleCompat("Tüm işlemler bir tık uzağında!")
            .navigationDestination(for: MenuAction.self ){ action in
                MenuPageRouter.getDetailView(for: action)
            }
        }
    }
    
}
