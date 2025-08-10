//
//  SearchViewModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedCategory = "Tümü"
    @Published var sortOption = "İsim"
    @Published var viewMode: ViewMode = .grid
    @Published var showFilters = false
    @Published var isShowingSearchable = false
    @Published var showRecentSearches = false
    @Published var recentSearches = ["organik domates", "yeşil yapraklar", "taze meyve"]
    @Published var filteredProducts: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let searchDebounceTime: Double = 0.5
    
    // MARK: - Constants
    let categories = ["Tümü", "Sebze", "Meyve", "Et", "Süt Ürünleri", "Tahıl", "İndirimli"]
    let sortOptions = ["İsim", "Fiyat (Düşük)", "Fiyat (Yüksek)", "Popülerlik", "Değerlendirme"]
    
    // MARK: - Sample Data
    private let allProducts = [
        Product(name: "Organik Domates", category: "Sebze", price: 12.50, originalPrice: 15.00, image: "🍅", isOrganic: true, description: "Taze organik domates", rating: 4.8, reviewCount: 124, isOnSale: true, stockStatus: .inStock, seasonality: "Yaz", nutritionHighlights: ["Potasyum", "B6"], origin: "Ekvador"),
        Product(name: "Yeşil Elma", category: "Meyve", price: 8.75, originalPrice: nil, image: "🍏", isOrganic: true, description: "Crispy yeşil elmalar", rating: 4.6, reviewCount: 89, isOnSale: false, stockStatus: .inStock, seasonality: "Sonbahar", nutritionHighlights: ["Potasyum", "B6"], origin: "Ekvador"),
        Product(name: "Organik Havuç", category: "Sebze", price: 6.25, originalPrice: nil, image: "🥕", isOrganic: true, description: "Taze organik havuç", rating: 4.9, reviewCount: 156, isOnSale: false, stockStatus: .lowStock, seasonality: nil, nutritionHighlights: ["Potasyum", "B6"], origin: "Ekvador"),
        Product(name: "Kırmızı Üzüm", category: "Meyve", price: 15.00, originalPrice: 20.00, image: "🍇", isOrganic: false, description: "Tatlı kırmızı üzüm", rating: 4.4, reviewCount: 73, isOnSale: true, stockStatus: .inStock, seasonality: "Yaz", nutritionHighlights: ["Potasyum", "B6"], origin: "Ekvador"),
        Product(name: "Organik Süt", category: "Süt Ürünleri", price: 18.50, originalPrice: nil, image: "🥛", isOrganic: true, description: "Çiftlik sütü", rating: 4.7, reviewCount: 201, isOnSale: false, stockStatus: .outOfStock, seasonality: nil, nutritionHighlights: ["Potasyum", "B6"], origin: "Ekvador"),
        Product(name: "Tam Buğday Ekmeği", category: "Tahıl", price: 22.00, originalPrice: 25.00, image: "🍞", isOrganic: true, description: "El yapımı tam buğday ekmeği", rating: 4.5, reviewCount: 95, isOnSale: true, stockStatus: .inStock, seasonality: nil, nutritionHighlights: ["Potasyum", "B6"], origin: "Ekvador")
    ]
    
    // MARK: - Initialization
    init() {
        setupBindings()
        filteredProducts = allProducts
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        // Debounce search text changes
        $searchText
            .debounce(for: .seconds(searchDebounceTime), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.filterProducts()
                self?.updateRecentSearches()
            }
            .store(in: &cancellables)
        
        // React to category changes
        $selectedCategory
            .sink { [weak self] _ in
                self?.filterProducts()
            }
            .store(in: &cancellables)
        
        // React to sort option changes
        $sortOption
            .sink { [weak self] _ in
                self?.filterProducts()
            }
            .store(in: &cancellables)
        
        // Show/hide recent searches based on search text
        $searchText
            .map { $0.isEmpty && self.isShowingSearchable }
            .assign(to: \.showRecentSearches, on: self)
            .store(in: &cancellables)
    }
    
    private func filterProducts() {
        isLoading = true
        errorMessage = nil
        
        var result = allProducts
        
        // Apply search filter
        if !searchText.isEmpty {
            result = result.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.description.localizedCaseInsensitiveContains(searchText) ||
                product.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply category filter
        if selectedCategory != "Tümü" {
            if selectedCategory == "İndirimli" {
                result = result.filter { $0.isOnSale }
            } else {
                result = result.filter { $0.category == selectedCategory }
            }
        }
        
        // Apply sorting
        result = sortProducts(result)
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.filteredProducts = result
            self.isLoading = false
        }
    }
    
    private func sortProducts(_ products: [Product]) -> [Product] {
        switch sortOption {
        case "Fiyat (Düşük)":
            return products.sorted { $0.price < $1.price }
        case "Fiyat (Yüksek)":
            return products.sorted { $0.price > $1.price }
        case "İsim":
            return products.sorted { $0.name < $1.name }
        case "Değerlendirme":
            return products.sorted { $0.rating > $1.rating }
        case "Popülerlik":
            return products.sorted { $0.reviewCount > $1.reviewCount }
        default:
            return products
        }
    }
    
    private func updateRecentSearches() {
        guard !searchText.isEmpty && searchText.count > 2 else { return }
        
        if !recentSearches.contains(searchText.lowercased()) {
            recentSearches.insert(searchText.lowercased(), at: 0)
            if recentSearches.count > 5 {
                recentSearches.removeLast()
            }
        }
    }
    
    // MARK: - Public Methods
    func selectRecentSearch(_ search: String) {
        searchText = search
        showRecentSearches = false
    }
    
    func clearRecentSearches() {
        recentSearches.removeAll()
    }
    
    func clearAllFilters() {
        searchText = ""
        selectedCategory = "Tümü"
        sortOption = "İsim"
    }
    
    func toggleViewMode() {
        viewMode = viewMode == .grid ? .list : .grid
    }
    
    func selectCategory(_ category: String) {
        selectedCategory = category
    }
    
    func selectSortOption(_ option: String) {
        sortOption = option
    }
    
    func refreshProducts() {
        filterProducts()
    }
    
    // MARK: - Computed Properties
    var hasActiveFilters: Bool {
        !searchText.isEmpty || selectedCategory != "Tümü"
    }
    
    var productCount: Int {
        filteredProducts.count
    }
    
    var isEmpty: Bool {
        filteredProducts.isEmpty && !isLoading
    }
    
    var shouldShowStats: Bool {
        hasActiveFilters
    }
    
    // MARK: - Search Statistics
    var searchStats: String {
        "\(productCount) ürün bulundu"
    }
    
    // MARK: - Category Management
    func getActiveFilterChips() -> [String] {
        var chips: [String] = []
        
        if selectedCategory != "Tümü" {
            chips.append(selectedCategory)
        }
        
        return chips
    }
    
    func removeFilterChip(_ chip: String) {
        if chip == selectedCategory {
            selectedCategory = "Tümü"
        }
    }
}

// MARK: - ViewMode Enum
enum ViewMode {
    case grid, list
    
    var icon: String {
        switch self {
        case .grid:
            return "square.grid.2x2"
        case .list:
            return "list.bullet"
        }
    }
}

// MARK: - Search Suggestions
extension SearchViewModel {
    func getSearchSuggestions(for query: String) -> [String] {
        guard !query.isEmpty else { return [] }
        
        let productNames = allProducts.map { $0.name.lowercased() }
        let categories = categories.map { $0.lowercased() }
        let allSuggestions = productNames + categories
        
        return allSuggestions.filter {
            $0.contains(query.lowercased())
        }.prefix(5).map { $0 }
    }
}
