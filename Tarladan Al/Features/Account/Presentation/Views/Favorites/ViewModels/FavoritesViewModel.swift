//
//  FavoritesViewModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/18/25.
//
import Foundation
import FirebaseFirestore

// MARK: - Favorites View Model
class FavoritesViewModel: ObservableObject {
    
    @Published var favoriteProducts: [Product] = []
    @Published var isLoading = false
    
    func toggleFavorite(_ product: Product) {
        if favoriteProducts.contains(where: { $0.id == product.id }) {
            favoriteProducts.removeAll { $0.id == product.id }
        } else {
            favoriteProducts.append(product)
        }
    }
    
    func isFavorite(_ product: Product) -> Bool {
        favoriteProducts.contains(where: { $0.id == product.id })
    }
    
    func loadFavorites() {
        isLoading = true
        // Simulate loading from Firebase
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.favoriteProducts = self.sampleFavoriteProducts()
            self.isLoading = false
        }
    }
    
    private func sampleFavoriteProducts() -> [Product] {
        return [
            Product(
                id: "fav1",
                farmerId: "farmer1",
                farmerName: "Ahmet Demir",
                farmerPhone: "+90 555 123 4567",
                categoryName: "Sebze",
                subCategoryName: "Yaprak Sebze",
                title: "Organik Ispanak",
                description: "Taze organik ıspanak, pestisit kullanılmadan yetiştirilmiştir. Vitamin ve mineral açısından zengin.",
                price: 25.0,
                unit: "kg",
                quantity: 15.0,
                images: ["ispanak1", "ispanak2"],
                location: GeoPoint(latitude: 21.324, longitude: 12.124),
                locationName: "Bursa, Nilüfer",
                createdAt: Date(),
                updatedAt: Date(),
                isActive: true,
                isOrganic: true,
                harvestDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()),
                expiryDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())
            ),
            Product(
                id: "fav2",
                farmerId: "farmer2",
                farmerName: "Fatma Kaya",
                farmerPhone: "+90 555 987 6543",
                categoryName: "Meyve",
                subCategoryName: "Turunçgiller",
                title: "Valencia Portakalı",
                description: "Antalya'nın bereketli topraklarından taze valencia portakalları. Doğal şeker oranı yüksek.",
                price: 18.0,
                unit: "kg",
                quantity: 25.0,
                images: ["portakal1"],
                location: GeoPoint(latitude: 21.324, longitude: 12.124),
                locationName: "Antalya, Finike",
                createdAt: Date(),
                updatedAt: Date(),
                isActive: true,
                isOrganic: false,
                harvestDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()),
                expiryDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())
            ),
            Product(
                id: "fav3",
                farmerId: "farmer3",
                farmerName: "Mehmet Özkan",
                farmerPhone: "+90 555 456 7890",
                categoryName: "Sebze",
                subCategoryName: "Kök Sebze",
                title: "Organik Havuç",
                description: "Topraktan taze çıkmış organik havuçlar. Beta karoten açısından zengin.",
                price: 20.0,
                unit: "kg",
                quantity: 8.0,
                images: ["havuc1"],
                location: GeoPoint(latitude: 21.324, longitude: 12.124),
                locationName: "Konya, Çumra",
                createdAt: Date(),
                updatedAt: Date(),
                isActive: true,
                isOrganic: true,
                harvestDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
                expiryDate: Calendar.current.date(byAdding: .day, value: 10, to: Date())
            ),
            Product(
                id: "fav4",
                farmerId: "farmer4",
                farmerName: "Zeynep Yılmaz",
                farmerPhone: "+90 555 234 5678",
                categoryName: "Meyve",
                subCategoryName: "Çekirdekli Meyve",
                title: "Starking Elma",
                description: "Isparta'nın soğuk ikliminde yetişen kırmızı starking elmaları. Çıtır ve tatlı.",
                price: 15.0,
                unit: "kg",
                quantity: 30.0,
                images: ["elma1"],
                location: GeoPoint(latitude: 21.324, longitude: 12.124),
                locationName: "Isparta, Merkez",
                createdAt: Date(),
                updatedAt: Date(),
                isActive: true,
                isOrganic: false,
                harvestDate: Calendar.current.date(byAdding: .day, value: -14, to: Date()),
                expiryDate: Calendar.current.date(byAdding: .day, value: 21, to: Date())
            )
        ]
    }
}
