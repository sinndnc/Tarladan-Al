//
//  RootView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI
import FirebaseFirestore

struct RootView: View {
    
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var rootViewModel: RootViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject private var deliveryViewModel: DeliveryViewModel
    
    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $rootViewModel.selectedTab){
                Tab("Home", systemImage: "house", value: .home) {
                    HomeView()
                        .tag(TabEnum.home)
                }
                Tab("Shops", systemImage:"cart",value: .shop){
                    ShopView()
                        .tag(TabEnum.shop)
                }
                .badge(cartViewModel.items.count)
                if (userViewModel.user?.accountType == .farmer){
                    Tab("Menu",systemImage: "line.3.horizontal",value: .search){
                        MenuView()
                            .tag(TabEnum.search)
                    }
                }
                Tab("Deliveries",systemImage: "truck.box",value: .deliveries){
                    DeliveryView()
                        .tag(TabEnum.deliveries)
                }
                Tab("Account", systemImage: "person.circle", value: .account) {
                    AccountView()
                        .tag(TabEnum.account)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    RootView()
}
