//
//  ShopViewModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation
import Combine


@MainActor
class ShopViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var quickActions: [QuickAction] = []
    @Published var selectedCategory: Category?
    @Published var showCart = false
    @Published var cartItemCount = 0
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Featured banner data
    @Published var featuredTitle = "🌱 Yaz Sezonu Özel"
    @Published var featuredDescription = "Taze yaz sebzeleri ve meyvelerinde %30'a varan indirimler"
    @Published var showFeaturedBanner = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadInitialData()
        setupQuickActions()
    }
    
    func loadInitialData() {
        isLoading = true
        
        // Simulate API call delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.categories = self.createSampleCategories()
            self.isLoading = false
        }
    }
    
    private func setupQuickActions() {
        quickActions = [
            QuickAction(
                icon: "star.fill",
                title: "En Popüler",
                subtitle: "150+ ürün",
                color: .yellow
            ) { [weak self] in
                self?.handleQuickAction(.popularity)
            },
            QuickAction(
                icon: "tag.fill",
                title: "İndirimli",
                subtitle: "45 ürün",
                color: .red
            ) { [weak self] in
                self?.handleQuickAction(.discount)
            },
            QuickAction(
                icon: "leaf.fill",
                title: "Yeni Ürünler",
                subtitle: "28 ürün",
                color: .green
            ) { [weak self] in
                self?.handleQuickAction(.newProducts)
            },
            QuickAction(
                icon: "clock.fill",
                title: "Hızlı Teslimat",
                subtitle: "2 saat içinde",
                color: .blue
            ) { [weak self] in
                self?.handleQuickAction(.fastDelivery)
            }
        ]
    }
    
    private func createSampleCategories() -> [Category] {
        return [
            Category(
                name: "vegetables",
                displayName: "Sebzeler",
                description: "Taze, organik sebzeler",
                icon: "🥬",
                color: .green,
                productCount: 85,
                isNew: false,
                isSeasonal: true,
                bannerImage: nil
            ),
            Category(
                name: "fruits",
                displayName: "Meyveler",
                description: "Mevsim meyveleri",
                icon: "🍎",
                color: .red,
                productCount: 62,
                isNew: false,
                isSeasonal: true,
                bannerImage: nil
            ),
            Category(
                name: "dairy",
                displayName: "Süt Ürünleri",
                description: "Çiftlik sütü ve peynirler",
                icon: "🥛",
                color: .blue,
                productCount: 34,
                isNew: false,
                isSeasonal: false,
                bannerImage: nil
            ),
            Category(
                name: "meat",
                displayName: "Et Ürünleri",
                description: "Organik et ve tavuk",
                icon: "🥩",
                color: .red,
                productCount: 28,
                isNew: false,
                isSeasonal: false,
                bannerImage: nil
            ),
            Category(
                name: "bakery",
                displayName: "Fırın Ürünleri",
                description: "Günlük taze ekmekler",
                icon: "🍞",
                color: .orange,
                productCount: 45,
                isNew: true,
                isSeasonal: false,
                bannerImage: nil
            ),
            Category(
                name: "pantry",
                displayName: "Kiler",
                description: "Tahıllar ve bakliyatlar",
                icon: "🌾",
                color: .brown,
                productCount: 67,
                isNew: false,
                isSeasonal: false,
                bannerImage: nil
            )
        ]
    }
    
    // MARK: - Actions
    
    func selectCategory(_ category: Category) {
        selectedCategory = category
    }
    
    func toggleCart() {
        showCart.toggle()
    }
    
    private func handleQuickAction(_ action: QuickActionType) {
        // Implement quick action logic
        switch action {
        case .popularity:
            // Navigate to popular products
            break
        case .discount:
            // Navigate to discounted products
            break
        case .newProducts:
            // Navigate to new products
            break
        case .fastDelivery:
            // Navigate to fast delivery products
            break
        }
    }
    
    func addToCart(product: Product) {
        cartItemCount += 1
        // Implement add to cart logic
    }
    
    func refreshData() {
        loadInitialData()
    }
}
