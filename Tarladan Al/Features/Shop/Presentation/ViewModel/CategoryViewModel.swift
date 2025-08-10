//
//  SortOption.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation
import Combine



@MainActor
class CategoryProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var sortOption: SortOption = .popularity
    @Published var selectedSubcategory = "Tümü"
    @Published var viewMode: ViewMode = .grid
    @Published var showFilters = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let category: Category
    private var cancellables = Set<AnyCancellable>()
    
    var subcategories: [String] {
        getSubcategories(for: category.name)
    }
    
    var sortOptions: [SortOption] {
        SortOption.allCases
    }
    
    init(category: Category) {
        self.category = category
        setupBindings()
        loadProducts()
    }
    
    private func setupBindings() {
        // Update filtered products when sort option or subcategory changes
        Publishers.CombineLatest3($products, $sortOption, $selectedSubcategory)
            .map { [weak self] products, sortOption, subcategory in
                self?.filterAndSortProducts(products, sortOption: sortOption, subcategory: subcategory) ?? []
            }
            .assign(to: &$filteredProducts)
    }
    
    func loadProducts() {
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.products = self.createSampleProducts(for: self.category.name)
            self.isLoading = false
        }
    }
    
    private func filterAndSortProducts(_ products: [Product], sortOption: SortOption, subcategory: String) -> [Product] {
        var result = products
        
        // Filter by subcategory (simplified implementation)
        if subcategory != "Tümü" {
            // In real implementation, you'd have more sophisticated filtering logic
            result = products // For now, return all products
        }
        
        // Sort products
        switch sortOption {
        case .priceLow:
            result = result.sorted { $0.price < $1.price }
        case .priceHigh:
            result = result.sorted { $0.price > $1.price }
        case .name:
            result = result.sorted { $0.name < $1.name }
        case .rating:
            result = result.sorted { $0.rating > $1.rating }
        case .popularity:
            result = result.sorted { $0.reviewCount > $1.reviewCount }
        }
        
        return result
    }
    
    private func getSubcategories(for categoryName: String) -> [String] {
        switch categoryName {
        case "vegetables":
            return ["Tümü", "Yapraklı", "Köklü", "Meyveli", "Soğansı"]
        case "fruits":
            return ["Tümü", "Mevsimsel", "Tropik", "Kırmızı Meyveler", "Turunçgiller"]
        case "dairy":
            return ["Tümü", "Süt", "Peynir", "Yoğurt", "Tereyağı"]
        case "meat":
            return ["Tümü", "Kırmızı Et", "Beyaz Et", "Balık", "Şarküteri"]
        case "bakery":
            return ["Tümü", "Ekmek", "Pasta", "Börek", "Kurabiye"]
        case "pantry":
            return ["Tümü", "Tahıllar", "Bakliyat", "Baharat", "Konserve"]
        default:
            return ["Tümü"]
        }
    }
    
    private func createSampleProducts(for categoryName: String) -> [Product] {
        switch categoryName {
        case "vegetables":
            return [
                Product(
                    name: "Organik Domates",
                    category: "vegetables",
                    price: 12.50,
                    originalPrice: 15.00,
                    image: "🍅",
                    isOrganic: true,
                    description: "Taze sera domatesi",
                    rating: 4.8,
                    reviewCount: 124,
                    isOnSale: true,
                    stockStatus: .inStock,
                    seasonality: "Yaz",
                    nutritionHighlights: ["Vitamin C", "Likopen"],
                    origin: "Antalya"
                ),
                Product(
                    name: "Baby Ispanak",
                    category: "vegetables",
                    price: 8.75,
                    originalPrice: nil,
                    image: "🥬",
                    isOrganic: true,
                    description: "Tender baby spinach",
                    rating: 4.6,
                    reviewCount: 89,
                    isOnSale: false,
                    stockStatus: .inStock,
                    seasonality: nil,
                    nutritionHighlights: ["Demir", "Folat"],
                    origin: "Bursa"
                ),
                Product(
                    name: "Organik Havuç",
                    category: "vegetables",
                    price: 6.25,
                    originalPrice: nil,
                    image: "🥕",
                    isOrganic: true,
                    description: "Tatlı organik havuç",
                    rating: 4.9,
                    reviewCount: 156,
                    isOnSale: false,
                    stockStatus: .lowStock,
                    seasonality: nil,
                    nutritionHighlights: ["Beta Karoten"],
                    origin: "Konya"
                ),
                Product(
                    name: "Brokoli",
                    category: "vegetables",
                    price: 9.75,
                    originalPrice: 12.00,
                    image: "🥦",
                    isOrganic: true,
                    description: "Taze brokoli",
                    rating: 4.7,
                    reviewCount: 98,
                    isOnSale: true,
                    stockStatus: .inStock,
                    seasonality: "Kış",
                    nutritionHighlights: ["Vitamin K", "C"],
                    origin: "İzmir"
                )
            ]
        case "fruits":
            return [
                Product(
                    name: "Organik Elma",
                    category: "fruits",
                    price: 15.00,
                    originalPrice: nil,
                    image: "🍎",
                    isOrganic: true,
                    description: "Kırmızı organik elma",
                    rating: 4.8,
                    reviewCount: 203,
                    isOnSale: false,
                    stockStatus: .inStock,
                    seasonality: "Sonbahar",
                    nutritionHighlights: ["Fiber", "C Vitamini"],
                    origin: "Isparta"
                ),
                Product(
                    name: "Çilek",
                    category: "fruits",
                    price: 25.00,
                    originalPrice: 30.00,
                    image: "🍓",
                    isOrganic: true,
                    description: "Taze mevsim çileği",
                    rating: 4.9,
                    reviewCount: 167,
                    isOnSale: true,
                    stockStatus: .inStock,
                    seasonality: "İlkbahar",
                    nutritionHighlights: ["Antioksidan", "C Vitamini"],
                    origin: "Bursa"
                )
            ]
        default:
            return []
        }
    }
    
    // MARK: - Actions
    
    func updateSortOption(_ option: SortOption) {
        sortOption = option
    }
    
    func selectSubcategory(_ subcategory: String) {
        selectedSubcategory = subcategory
    }
    
    func toggleViewMode() {
        viewMode = viewMode == .grid ? .list : .grid
    }
    
    func setViewMode(_ mode: ViewMode) {
        viewMode = mode
    }
    
    func toggleFilters() {
        showFilters.toggle()
    }
    
    func addToCart(_ product: Product) {
        // Implement add to cart logic
        print("Added \(product.name) to cart")
    }
    
    func refreshProducts() {
        loadProducts()
    }
}
