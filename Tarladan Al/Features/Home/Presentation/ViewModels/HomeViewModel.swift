//
//  HomeViewModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation

class HomeViewModel: ObservableObject {
    
    //MARK: - Data Models
    @Published var user: User? = nil
    @Published var deliveries: [Delivery] = []
    
    //MARK: - Published Properties
    @Published var selectedTab = 0
    @Published var showingProfile = false
    @Published var showingCart = false
    @Published var cartItemCount = 0
    @Published var showingLocation = false
    
    //MARK: - Data Properties
    @Published var products: [Product] = []
    @Published var categories: [Category] = []
    @Published var recipes: [Recipe] = []
    @Published var currentAddress: Address?
    @Published var deliveryStatus: DeliveryStatus?
    @Published var featuredBanner: Banner?
    
    //MARK: -  Loading States
    @Published var isLoadingProducts = false
    @Published var isLoadingCategories = false
    @Published var isLoadingRecipes = false
    @Published var isLoadingDeliveryStatus = false
    
    //MARK: -  Error Handling
    @Published var errorMessage: String?
    @Published var showingError = false
    
    // MARK: - Computed Properties
    var popularProducts: [Product] {
        products.filter { $0.rating >= 4.5 }.sorted { $0.reviewCount > $1.reviewCount }
    }
    
    var seasonalProducts: [Product] {
        products.filter { $0.seasonality != nil }.prefix(6).map { $0 }
    }
    
    var onSaleProducts: [Product] {
        products.filter { $0.isOnSale }
    }
    
    func toggleBell() {}
    
}

extension HomeViewModel{
    
    
    var quickActions: [QuickAction] {
        [
            QuickAction(
                icon: "clock.arrow.circlepath",
                title: "Tekrar Sipariş",
                subtitle: "Önceki siparişin",
                color: .blue
            ) {
                
            },
            QuickAction(
                icon: "heart.fill",
                title: "Favoriler",
                subtitle: "Beğendiğin ürünler",
                color: .blue)
            {
                
            },
            QuickAction(
                icon: "percent",
                title: "İndirimler",
                subtitle: "Özel fırsatlar",
                color: .blue
            ) {
                
            },
            QuickAction(
                icon: "gift.fill",
                title: "Hediye Kutusu",
                subtitle: "Özel paketler",
                color: .blue
            ) {
                
            }
        ]
    }
    
}
