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
  
    @Published var isLoading = false
    @Published var showScan = false
    @Published var errorMessage: String?
    @Published var isShowingSearchable = false
    @Published var showRecentSearches = false
    
    @Published var searchText: String = ""
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var categories: [ProductCategory] = []
    @Published var selectedCategory : ProductCategory?
    
    private var cancellables = Set<AnyCancellable>()
    private let searchDebounceTime: Double = 0.5
    
    @Injected private var listenProductsUseCase : ListenProductsUseCaseProtocol
    
    init() {
        self.loadProducts()
        self.categories = ShopViewModel.shared.categories
    }
    
    func loadProducts() {
        listenProductsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        Logger.log("✅ VIEW MODEL: Completed successfully")
                    case .failure(let error):
                        Logger.log("❌ VIEW MODEL: Error: \(error)")
                    }
                },
                receiveValue: { [weak self] products in
                    self?.products = products
                }
            )
            .store(in: &cancellables)
    }
    
    func filteredProducts(category: ProductCategory?, searchText: String) -> [Product] {
        var filtered = products
        
        // Kategori filtresi
        if let category = category {
            filtered = filtered.filter { $0.categoryName == category.name }
        }
        
        // Arama filtresi
        if !searchText.isEmpty {
            filtered = filtered.filter { product in
                product.title.localizedCaseInsensitiveContains(searchText) ||
                product.description.localizedCaseInsensitiveContains(searchText) ||
                product.farmerName.localizedCaseInsensitiveContains(searchText) ||
                product.locationName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    // Kategorilere göre ürün sayısı
    func productCount(for category: ProductCategory) -> Int {
        products.filter { $0.categoryName == category.name }.count
    }
    
}

extension SearchViewModel {
   
}
