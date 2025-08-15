//
//  RootView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI

class RootViewModel: ObservableObject {
    @Published var selectedTab: TabEnum = .home
}

struct RootView: View {
    
    @StateObject private var rootViewModel = RootViewModel()
    @StateObject private var shopViewModel = ShopViewModel()
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
    @StateObject private var deliveryViewModel = DeliveryViewModel()
    
    
    @EnvironmentObject private var userViewModel: UserViewModel
    
    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $rootViewModel.selectedTab){
                Tab("Home", systemImage: "house", value: .home) {
                    HomeView()
                        .tag(TabEnum.home)
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                }
                Tab("Shops", systemImage:"cart.fill",value: .shop){
                    ShopView()
                        .tag(TabEnum.shop)
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                }
                Tab("Search",systemImage: "magnifyingglass",value: .search){
                    SearchView()
                        .tag(TabEnum.search)
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                }
                Tab("Deliveries",systemImage: "truck.box.fill",value: .deliveries){
                    DeliveryView()
                        .tag(TabEnum.deliveries)
                        .environmentObject(deliveryViewModel)
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                }
                Tab("Account", systemImage: "person.circle.fill", value: .account) {
                    AccountView()
                        .tag(TabEnum.account)
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .environmentObject(rootViewModel)
        .environmentObject(userViewModel)
        .environmentObject(shopViewModel)
        .environmentObject(cartViewModel)
        .environmentObject(searchViewModel)
        .environmentObject(deliveryViewModel)
        .onAppear{
            deliveryViewModel.listenDeliveries(by: "")
        }
    }
}

#Preview {
    RootView()
}
