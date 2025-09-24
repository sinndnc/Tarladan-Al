//
//  RecipeViewModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/15/25.
//

import Foundation
import SwiftUI
import Combine

class RecipeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var recipes: [Recipe] = []
    @Published var filteredRecipes: [Recipe] = []
    @Published var favoriteRecipes: [Recipe] = []
    @Published var searchText: String = "" {
        didSet {
            filterRecipes()
        }
    }
    @Published var selectedCategory: Recipe.Category? {
        didSet {
            filterRecipes()
        }
    }
    @Published var selectedDifficulty: Recipe.Difficulty? {
        didSet {
            filterRecipes()
        }
    }
    
    // MARK: - Loading States
    @Published var isLoading: Bool = false
    @Published var isUploading: Bool = false
    @Published var loadingMessage: String = ""
    @Published var errorMessage: String?
    
    // MARK: - Firebase References
    private var cancellables = Set<AnyCancellable>()
    
    @Injected private var listenRecipesUseCase: ListenRecipesUseCaseProtocol
    
    init() {
        setupSearchDebounce()
        loadRecipes()
    }
    
    func loadRecipes() {
        isLoading = true
        listenRecipesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
            } receiveValue: { recipes in
                self.recipes = recipes
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.filterRecipes()
            }
            .store(in: &cancellables)
    }
    
    func filterRecipes() {
        var filtered = recipes
        
        // Search text filter
        if !searchText.isEmpty {
            filtered = filtered.filter { recipe in
                recipe.title.localizedCaseInsensitiveContains(searchText) ||
                recipe.description.localizedCaseInsensitiveContains(searchText) ||
                recipe.tags.contains { $0.localizedCaseInsensitiveContains(searchText) } ||
                recipe.ingredients.contains { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        // Category filter
        if let selectedCategory = selectedCategory {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        // Difficulty filter
        if let selectedDifficulty = selectedDifficulty {
            filtered = filtered.filter { $0.difficulty == selectedDifficulty }
        }
        
        filteredRecipes = filtered
    }
    
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
        selectedDifficulty = nil
    }
    
    // MARK: - Sorting
    
    func sortRecipes(by sortOption: RecipeSortOption) {
        switch sortOption {
        case .titleAscending:
            filteredRecipes.sort { $0.title < $1.title }
        case .titleDescending:
            filteredRecipes.sort { $0.title > $1.title }
        case .prepTimeAscending:
            filteredRecipes.sort { $0.totalTime < $1.totalTime }
        case .prepTimeDescending:
            filteredRecipes.sort { $0.totalTime > $1.totalTime }
        case .difficultyAscending:
            filteredRecipes.sort { $0.difficulty.rawValue < $1.difficulty.rawValue }
        case .difficultyDescending:
            filteredRecipes.sort { $0.difficulty.rawValue > $1.difficulty.rawValue }
        case .newest:
            // Already sorted by createdAt in Firebase query
            break
        }
    }
    
//    func toggleFavorite(_ recipe: Recipe) {
//        if favoriteRecipeIDs.contains(recipe.id ?? "" ) {
//            removeFavorite(recipe)
//        } else {
//            addFavorite(recipe)
//        }
//    }
//    
//    func addFavorite(_ recipe: Recipe) {
//        favoriteRecipeIDs.insert(recipe.id ?? "" )
//        saveFavoriteIDs()
//        updateFavoriteRecipes()
//    }
//    
//    func removeFavorite(_ recipe: Recipe) {
//        favoriteRecipeIDs.remove(recipe.id ?? "" )
//        saveFavoriteIDs()
//        updateFavoriteRecipes()
//    }
//    
//    func isFavorite(_ recipe: Recipe) -> Bool {
//        return favoriteRecipeIDs.contains(recipe.id ?? "" )
//    }
//    
//    private func updateFavoriteRecipes() {
//        favoriteRecipes = recipes.filter { favoriteRecipeIDs.contains($0.id ?? "" ) }
//    }
//    
//    private func loadFavoriteIDs() {
//        if let data = UserDefaults.standard.data(forKey: favoritesKey),
//           let favoriteIDs = try? JSONDecoder().decode(Set<String>.self, from: data) {
//            favoriteRecipeIDs = favoriteIDs
//        }
//    }
//    
//    private func saveFavoriteIDs() {
//        if let data = try? JSONEncoder().encode(favoriteRecipeIDs) {
//            UserDefaults.standard.set(data, forKey: favoritesKey)
//        }
//    }
    
    // MARK: - Recipe Statistics
    
    var totalRecipes: Int {
        recipes.count
    }
    
    var recipesByCategory: [Recipe.Category: Int] {
        Dictionary(grouping: recipes, by: { $0.category })
            .mapValues { $0.count }
    }
    
    var recipesByDifficulty: [Recipe.Difficulty: Int] {
        Dictionary(grouping: recipes, by: { $0.difficulty })
            .mapValues { $0.count }
    }
    
    var averagePrepTime: Double {
        guard !recipes.isEmpty else { return 0 }
        let total = recipes.reduce(0) { $0 + $1.totalTime }
        return Double(total) / Double(recipes.count)
    }
    
    // MARK: - Error Handling
    
    func clearError() {
        errorMessage = nil
    }
}

enum RecipeSortOption: String, CaseIterable {
    case newest = "En Yeni"
    case titleAscending = "İsim (A-Z)"
    case titleDescending = "İsim (Z-A)"
    case prepTimeAscending = "Süre (Az-Çok)"
    case prepTimeDescending = "Süre (Çok-Az)"
    case difficultyAscending = "Kolay-Zor"
    case difficultyDescending = "Zor-Kolay"
}
