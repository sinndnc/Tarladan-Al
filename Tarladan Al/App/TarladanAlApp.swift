//
//  Tarladan_AlApp.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI

@main
struct Tarladan_AlApp: App {
    
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var languageManager = LanguageManager()
    
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var rootViewModel = RootViewModel()
    @StateObject private var shopViewModel = ShopViewModel()
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var menuViewModel = MenuViewModel()
    @StateObject private var orderViewModel = OrderViewModel()
    @StateObject private var recipeViewModel = RecipeViewModel()
    @StateObject private var productViewModel = ProductViewModel()
    @StateObject private var accountViewModel = AccountViewModel()
    @StateObject private var deliveryViewModel = DeliveryViewModel()
    
    @UIApplicationDelegateAdaptor(TarladanAlAppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView()
                .preferredColorScheme(themeManager.currentTheme.toColorScheme)
                .environmentObject(themeManager)
                .environmentObject(languageManager)
                .environmentObject(userViewModel)
                .environmentObject(rootViewModel)
                .environmentObject(userViewModel)
                .environmentObject(shopViewModel)
                .environmentObject(cartViewModel)
                .environmentObject(menuViewModel)
                .environmentObject(orderViewModel)
                .environmentObject(recipeViewModel)
                .environmentObject(productViewModel)
                .environmentObject(accountViewModel)
                .environmentObject(deliveryViewModel)
              
        }
    }
}
