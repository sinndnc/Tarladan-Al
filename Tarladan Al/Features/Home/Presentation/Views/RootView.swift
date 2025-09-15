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
    @StateObject private var orderViewModel = OrderViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
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
                        .toolbarColorScheme(.dark, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                        .toolbarBackground(Colors.UI.tabBackground, for: .tabBar)
                }
                Tab("Shops", systemImage:"cart.fill",value: .shop){
                    ShopView()
                        .tag(TabEnum.shop)
                        .toolbarColorScheme(.dark, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                        .toolbarBackground(Colors.UI.tabBackground, for: .tabBar)
                }
                .badge(cartViewModel.uniqueItemsCount)
                Tab("Search",systemImage: "magnifyingglass",value: .search){
                    SearchView()
                        .tag(TabEnum.search)
                        .toolbarColorScheme(.dark, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                        .toolbarBackground(Colors.UI.tabBackground, for: .tabBar)
                }
                Tab("Deliveries",systemImage: "truck.box.fill",value: .deliveries){
                    DeliveryView()
                        .tag(TabEnum.deliveries)
                        .toolbarColorScheme(.dark, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                        .toolbarBackground(Colors.UI.tabBackground, for: .tabBar)
                }
                Tab("Account", systemImage: "person.circle.fill", value: .account) {
                    AccountView()
                        .tag(TabEnum.account)
                        .toolbarColorScheme(.dark, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                        .toolbarBackground(Colors.UI.tabBackground, for: .tabBar)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .environmentObject(rootViewModel)
        .environmentObject(userViewModel)
        .environmentObject(shopViewModel)
        .environmentObject(cartViewModel)
        .environmentObject(orderViewModel)
        .environmentObject(searchViewModel)
        .environmentObject(recipeViewModel)
        .environmentObject(productViewModel)
        .environmentObject(accountViewModel)
        .environmentObject(deliveryViewModel)
        .onAppear {
//            let recipesData = RecipeMockData.convertToFirebaseData()
//            let db = Firestore.firestore()
//            let batch = db.batch()
//
//            for recipeData in recipesData {
//                let docRef = db.collection("recipes").document()
//                batch.setData(recipeData, forDocument: docRef)
//            }
//
//            batch.commit { error in
//                if let error = error {
//                    print("Error writing batch: \(error)")
//                } else {
//                    print("Batch write succeeded.")
//                }
//            }
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
