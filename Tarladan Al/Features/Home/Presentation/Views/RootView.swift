//
//  RootView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI
import FirebaseFirestore

class RootViewModel: ObservableObject {
    @Published var selectedTab: TabEnum = .home
}

struct RootView: View {
    
    @StateObject private var rootViewModel = RootViewModel()
    @StateObject private var shopViewModel = ShopViewModel()
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var menuViewModel = MenuViewModel()
    @StateObject private var orderViewModel = OrderViewModel()
    @StateObject private var recipeViewModel = RecipeViewModel()
    @StateObject private var productViewModel = ProductViewModel()
    @StateObject private var accountViewModel = AccountViewModel()
    @StateObject private var deliveryViewModel = DeliveryViewModel()
    
    @EnvironmentObject private var userViewModel: UserViewModel
    
    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $rootViewModel.selectedTab){
                Tab("Home", systemImage: "house", value: .home) {
                    HomeView()
                        .tag(TabEnum.home)
                }
                Tab("Shops", systemImage:"cart.fill",value: .shop){
                    ShopView()
                        .tag(TabEnum.shop)
                }
                .badge(cartViewModel.items.count)
                Tab("Menu",systemImage: "line.3.horizontal",value: .search){
                    MenuView()
                        .tag(TabEnum.search)
                }
                Tab("Deliveries",systemImage: "truck.box.fill",value: .deliveries){
                    DeliveryView()
                        .tag(TabEnum.deliveries)
                }
                Tab("Account", systemImage: "person.circle.fill", value: .account) {
                    AccountView()
                        .tag(TabEnum.account)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .environmentObject(rootViewModel)
        .environmentObject(userViewModel)
        .environmentObject(shopViewModel)
        .environmentObject(cartViewModel)
        .environmentObject(orderViewModel)
        .environmentObject(recipeViewModel)
        .environmentObject(productViewModel)
        .environmentObject(accountViewModel)
        .environmentObject(deliveryViewModel)
        .onAppear {
            orderViewModel.setUser(userViewModel.user)
            shopViewModel.setUser(userViewModel.user)
        }
        .onChange(of: userViewModel.user) { oldUser, newUser in
            orderViewModel.setUser(newUser)
            shopViewModel.setUser(newUser)
        }
    }
}

#Preview {
    RootView()
}
