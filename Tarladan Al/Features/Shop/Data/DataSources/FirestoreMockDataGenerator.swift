//
//  FirestoreMockDataGenerator.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//

import Foundation
import FirebaseFirestore
import CoreLocation
import SwiftUI

// MARK: - Mock Data Generator
class FirestoreMockDataGenerator {
    private let db = Firestore.firestore()
    private let categoriesData = ShopViewModel.shared
    
    // Türkiye'deki başlıca tarım şehirleri ve koordinatları
    private let turkishCities: [(name: String, latitude: Double, longitude: Double)] = [
        ("Antalya Merkez", 36.8969, 30.7133),
        ("Bursa Nilüfer", 40.2669, 29.0634),
        ("İzmir Bornova", 38.4619, 27.2178),
        ("Ankara Çankaya", 39.9208, 32.8541),
        ("Adana Seyhan", 37.0000, 35.3213),
        ("Mersin Tarsus", 36.9177, 34.8819),
        ("Manisa Salihli", 38.4823, 28.1414),
        ("Aydın Nazilli", 37.9143, 28.3529),
        ("Muğla Fethiye", 36.6211, 29.1161),
        ("Isparta Merkez", 37.7648, 30.5563),
        ("Konya Selçuklu", 37.8667, 32.4833),
        ("Samsun İlkadım", 41.2867, 36.3300),
        ("Trabzon Ortahisar", 41.0015, 39.7178),
        ("Rize Merkez", 41.0201, 40.5234),
        ("Artvin Merkez", 41.1828, 41.8183),
        ("Ordu Altınordu", 40.9839, 37.8764),
        ("Giresun Merkez", 40.9128, 38.3895),
        ("Çanakkale Merkez", 40.1553, 26.4142),
        ("Balıkesir Bandırma", 40.3520, 27.9777),
        ("Tekirdağ Süleymanpaşa", 40.9789, 27.5131),
        ("Edirne Merkez", 41.6818, 26.5623),
        ("Kırklareli Merkez", 41.7333, 27.2167),
        ("Hatay İskenderun", 36.5875, 36.1737),
        ("Gaziantep Şahinbey", 37.0662, 37.3833),
        ("Şanlıurfa Haliliye", 37.1591, 38.7969)
    ]
    
    // Çiftçi profilleri
    private let farmerProfiles: [(name: String, phone: String, experience: String)] = [
        ("Mehmet Yılmaz", "+905321234567", "25 yıllık deneyim"),
        ("Ayşe Kaya", "+905321234568", "15 yıllık organik tarım"),
        ("Hasan Demir", "+905321234569", "30 yıllık aile işletmesi"),
        ("Fatma Öztürk", "+905321234570", "10 yıllık sera üretimi"),
        ("Ali Şahin", "+905321234571", "20 yıllık meyve üretimi"),
        ("Emine Çelik", "+905321234572", "12 yıllık sebze üretimi"),
        ("Mustafa Arslan", "+905321234573", "18 yıllık hayvancılık"),
        ("Zeynep Koç", "+905321234574", "8 yıllık arıcılık"),
        ("İbrahim Yıldız", "+905321234575", "22 yıllık tahıl üretimi"),
        ("Hatice Güneş", "+905321234576", "14 yıllık organik üretim"),
        ("Osman Karaca", "+905321234577", "16 yıllık meyve bahçesi"),
        ("Meryem Avcı", "+905321234578", "11 yıllık sera işletmesi"),
        ("Ahmet Polat", "+905321234579", "28 yıllık tarım deneyimi"),
        ("Şerife Erdoğan", "+905321234580", "9 yıllık süt üretimi"),
        ("Süleyman Tekin", "+905321234581", "19 yıllık zeytin üretimi")
    ]
    
    // Mock ürün açıklamaları
    private let productDescriptions: [String: [String]] = [
        "generic": [
            "Taze ve kaliteli ürün",
            "Doğal yöntemlerle yetiştirilmiş",
            "Kimyasal gübre kullanılmadan üretilmiş",
            "Aile işletmesinde özenle yetiştirildi",
            "Günlük taze olarak hasat ediliyor"
        ],
        "fruits": [
            "Ağacından taze koparıldı",
            "Güneş altında doğal olarak olgunlaştı",
            "Pestisit kullanılmadan yetiştirildi",
            "Vitamin ve mineral bakımından zengin",
            "Mevsiminin en lezzetli dönemi"
        ],
        "vegetables": [
            "Topraktan taze çıkarıldı",
            "Organik gübrelerle beslendi",
            "Su kalitesi kontrol altında",
            "El emeği ile özenle bakıldı",
            "Sera koşullarında korundu"
        ],
        "dairy": [
            "Günlük taze sağım",
            "Hijyenik koşullarda üretildi",
            "Katkı maddesi içermez",
            "Soğuk zincirde muhafaza edildi",
            "Veteriner hekim kontrolünde"
        ],
        "grains": [
            "Bu sezon hasat edildi",
            "Temiz ve elenir durumdadır",
            "Doğal kurutma yöntemi kullanıldı",
            "Nem oranı ideal seviyede",
            "Yabancı madde ayıklandı"
        ],
        "honey": [
            "Ham ve işlenmemiş",
            "Doğal arı kovanlarından",
            "Çiçek nektarından üretildi",
            "Katkı maddesi eklenmedi",
            "Geleneksel yöntemlerle toplandı"
        ]
    ]
    
    func generateMockData() async {
        print("🌱 Mock data oluşturuluyor...")
        
        // Kategori başına ürün sayıları
        let productCountPerCategory = [
            "Meyveler": 25,
            "Sebzeler": 30,
            "Tahıllar & Baklagiller": 15,
            "Süt Ürünleri": 20,
            "Et & Su Ürünleri": 10,
            "Bal & Arıcılık": 12,
            "Baharat & Çeşniler": 15,
            "Kuru Meyve & Kuruyemiş": 18,
            "Zeytin & Zeytinyağı": 12,
            "İçecekler & Şıra": 10,
            "Mantarlar": 8,
            "Çiçek & Süs Bitkileri": 15,
            "Tıbbi & Aromatik Bitkiler": 12
        ]
        
        var totalProducts = 0
        
        for category in categoriesData.categories {
            let productCount = productCountPerCategory[category.name] ?? 10
            
            for subCategory in category.subCategories {
                let productsForSubCategory = min(productCount / category.subCategories.count + 1, 5)
                
                for i in 0..<productsForSubCategory {
                    let mockProduct = generateMockProduct(
                        category: category,
                        subCategory: subCategory,
                        index: i
                    )
                    
                    await saveMockProduct(mockProduct)
                    totalProducts += 1
                }
            }
            
            print("✅ \(category.name) kategorisi için ürünler oluşturuldu")
        }
        
        print("🎉 Toplam \(totalProducts) mock ürün Firebase'e kaydedildi!")
        
        // Kullanıcı profilleri de ekleyelim
        await generateFarmerProfiles()
    }
    
    private func generateMockProduct(category: ProductCategory, subCategory: ProductSubCategory, index: Int) -> Product {
        let farmer = farmerProfiles.randomElement()!
        let city = turkishCities.randomElement()!
        
        // Fiyat aralıkları (kategori bazlı)
        let priceRange = getPriceRange(for: category.name)
        let price = Double.random(in: priceRange.min...priceRange.max)
        
        // Miktar aralıkları
        let quantityRange = getQuantityRange(for: subCategory.defaultUnit)
        let quantity = Double.random(in: quantityRange.min...quantityRange.max)
        
        // Organik olma oranı
        let isOrganic : Bool = .random() // %30 şansla organik
        
        // Açıklama seçimi
        let categoryKey = getCategoryDescriptionKey(for: category.name)
        let descriptions = productDescriptions[categoryKey] ?? productDescriptions["generic"]!
        let baseDescription = descriptions.randomElement()!
        
        let fullDescription = generateDetailedDescription(
            baseDescription: baseDescription,
            subCategory: subCategory,
            isOrganic: isOrganic,
            farmer: farmer
        )
        
        // Hasat tarihi (son 30 gün içinde rastgele)
        let harvestDate = Calendar.current.date(byAdding: .day, value: -Int.random(in: 1...30), to: Date()) ?? Date()
        
        // Son kullanma tarihi
        let expiryDate = Calendar.current.date(byAdding: .day, value: subCategory.shelfLife, to: harvestDate)
        
        return Product(
            farmerId: "farmer_\(farmer.name.replacingOccurrences(of: " ", with: "_").lowercased())",
            farmerName: farmer.name,
            farmerPhone: farmer.phone,
            categoryName: category.name,
            subCategoryName: subCategory.name,
            title: generateProductTitle(subCategory: subCategory, index: index, isOrganic: isOrganic),
            description: fullDescription,
            price: price,
            unit: subCategory.defaultUnit.rawValue,
            quantity: quantity,
            images: generateMockImageURLs(count: Int.random(in: 2...5)),
            location: GeoPoint(latitude: city.latitude, longitude: city.longitude),
            locationName: city.name,
            createdAt: generateRandomDate(daysBack: 7),
            updatedAt: Date(),
            isActive: .random(),
            isOrganic: isOrganic,
            harvestDate: harvestDate,
            expiryDate: expiryDate
        )
    }
    
    private func generateProductTitle(subCategory: ProductSubCategory, index: Int, isOrganic: Bool) -> String {
        let baseTitle = subCategory.name
        let variants = subCategory.variants
        
        var title = baseTitle
        
        // Çeşit ekle
        if !variants.isEmpty && Bool.random() {
            title += " - \(variants.randomElement()!)"
        }
        
        // Kalite/özellik ekle
        let qualifiers = ["Premium", "A Kalite", "Seçme", "İri", "Orta Boy", "Ufak"]
        if Bool.random() {
            title = "\(qualifiers.randomElement()!) \(title)"
        }
        
        // Organik etiketi
        if isOrganic {
            title = "Organik \(title)"
        }
        
        // Bölge/özellik ekle
        let regionQualifiers = ["Köy", "Çiftlik", "Bahçe", "Sera", "Doğal"]
        if Bool.random() {
            title += " (\(regionQualifiers.randomElement()!))"
        }
        
        return title
    }
    
    private func generateDetailedDescription(baseDescription: String, subCategory: ProductSubCategory, isOrganic: Bool, farmer: (name: String, phone: String, experience: String)) -> String {
        var description = baseDescription
        
        // Çiftçi deneyimi ekle
        description += " \(farmer.experience) olan çiftçimiz tarafından üretilmektedir."
        
        // Organik bilgisi
        if isOrganic {
            description += " Organik tarım sertifikamız bulunmaktadır."
        }
        
        // Saklama bilgisi
        let storageInfo = getStorageDescription(for: subCategory.storageType)
        description += " \(storageInfo)"
        
        // Mevsim bilgisi
        let currentMonth = Calendar.current.component(.month, from: Date())
        if subCategory.seasonalityMonths.contains(currentMonth) {
            description += " Şu anda mevsiminin en uygun dönemi."
        }
        
        // Ek özellikler
        let additionalFeatures = [
            "Günlük hasat yapılmaktadır.",
            "Sipariş üzerine taze toplanır.",
            "Kargo ile gönderim yapılır.",
            "Toptan satış da mevcuttur.",
            "Düzenli müşterilerimize indirim uygulanır."
        ]
        
        if Bool.random() {
            description += " \(additionalFeatures.randomElement()!)"
        }
        
        return description
    }
    
    private func getStorageDescription(for storageType: StorageType) -> String {
        switch storageType {
        case .refrigerated:
            return "Soğuk zincirde muhafaza edilmelidir."
        case .frozen:
            return "Dondurulmuş olarak saklanmalıdır."
        case .dryPlace:
            return "Kuru ve serin yerde muhafaza ediniz."
        case .roomTemperature:
            return "Oda sıcaklığında saklanabilir."
        case .cellar:
            return "Serin ve karanlık yerde muhafaza edilir."
        }
    }
    
    private func getCategoryDescriptionKey(for categoryName: String) -> String {
        switch categoryName {
        case "Meyveler":
            return "fruits"
        case "Sebzeler":
            return "vegetables"
        case "Süt Ürünleri":
            return "dairy"
        case "Tahıllar & Baklagiller":
            return "grains"
        case "Bal & Arıcılık":
            return "honey"
        default:
            return "generic"
        }
    }
    
    private func getPriceRange(for categoryName: String) -> (min: Double, max: Double) {
        switch categoryName {
        case "Meyveler":
            return (5.0, 25.0)
        case "Sebzeler":
            return (3.0, 20.0)
        case "Tahıllar & Baklagiller":
            return (8.0, 35.0)
        case "Süt Ürünleri":
            return (6.0, 40.0)
        case "Et & Su Ürünleri":
            return (45.0, 150.0)
        case "Bal & Arıcılık":
            return (80.0, 300.0)
        case "Baharat & Çeşniler":
            return (15.0, 80.0)
        case "Kuru Meyve & Kuruyemiş":
            return (25.0, 120.0)
        case "Zeytin & Zeytinyağı":
            return (12.0, 85.0)
        case "İçecekler & Şıra":
            return (8.0, 25.0)
        case "Mantarlar":
            return (20.0, 60.0)
        case "Çiçek & Süs Bitkileri":
            return (5.0, 50.0)
        case "Tıbbi & Aromatik Bitkiler":
            return (25.0, 150.0)
        default:
            return (5.0, 50.0)
        }
    }
    
    private func getQuantityRange(for unit: MeasurementUnit) -> (min: Double, max: Double) {
        switch unit {
        case .kilogram:
            return (1.0, 500.0)
        case .gram:
            return (100.0, 5000.0)
        case .ton:
            return (0.5, 10.0)
        case .piece:
            return (10.0, 1000.0)
        case .bunch:
            return (5.0, 100.0)
        case .basket:
            return (2.0, 50.0)
        case .box:
            return (1.0, 20.0)
        case .bag:
            return (1.0, 100.0)
        case .liter:
            return (1.0, 100.0)
        case .bottle:
            return (5.0, 200.0)
        case .jar:
            return (3.0, 50.0)
        case .package:
            return (5.0, 100.0)
        case .dozen:
            return (2.0, 20.0)
        case .meter:
            return (1.0, 100.0)
        case .squareMeter:
            return (1.0, 1000.0)
        }
    }
    
    private func generateMockImageURLs(count: Int) -> [String] {
        return (1...count).map { index in
            "https://picsum.photos/400/300?random=\(Int.random(in: 1000...9999))"
        }
    }
    
    private func generateRandomDate(daysBack: Int) -> Date {
        let randomDays = Int.random(in: 0...daysBack)
        return Calendar.current.date(byAdding: .day, value: -randomDays, to: Date()) ?? Date()
    }
    
    private func saveMockProduct(_ product: Product) async {
        do {
            _ = try db.collection("products").addDocument(from: product)
            print("✅ Ürün kaydedildi: \(product.title)")
        } catch {
            print("❌ Hata: \(product.title) kaydedilemedi - \(error.localizedDescription)")
        }
    }
    
    private func generateFarmerProfiles() async {
        print("👨‍🌾 Çiftçi profilleri oluşturuluyor...")
        
        for (index, farmer) in farmerProfiles.enumerated() {
            let city = turkishCities[index % turkishCities.count]
            
            let farmerProfile: [String: Any] = [
                "id": "farmer_\(farmer.name.replacingOccurrences(of: " ", with: "_").lowercased())",
                "name": farmer.name,
                "phone": farmer.phone,
                "email": "\(farmer.name.replacingOccurrences(of: " ", with: ".").lowercased())@email.com",
                "location": GeoPoint(latitude: city.latitude, longitude: city.longitude),
                "locationName": city.name,
                "experience": farmer.experience,
                "rating": Double.random(in: 3.5...5.0),
                "totalSales": Int.random(in: 10...500),
                "joinDate": generateRandomDate(daysBack: 365),
                "isVerified": Bool.random() ? true : (Double.random(in: 0...1) < 0.8), // %80 doğrulanmış
                "specialties": generateRandomSpecialties(),
                "farmSize": "\(Int.random(in: 1...50)) dekar",
                "certifications": generateRandomCertifications(),
                "about": generateFarmerBio(farmer: farmer, city: city.name)
            ]
            
            do {
                try await db.collection("farmers").document(farmerProfile["id"] as! String).setData(farmerProfile)
                print("✅ Çiftçi kaydedildi: \(farmer.name)")
            } catch {
                print("❌ Çiftçi kayıt hatası: \(error.localizedDescription)")
            }
        }
        
        print("🎉 Çiftçi profilleri oluşturuldu!")
    }
    
    private func generateRandomSpecialties() -> [String] {
        let allSpecialties = ["Organik Tarım", "Sera Üretimi", "Meyve Bahçesi", "Sebze Üretimi", 
                             "Arıcılık", "Hayvancılık", "Tahıl Üretimi", "Çiçek Üretimi", 
                             "Mantar Üretimi", "Zeytin Üretimi"]
        let count = Int.random(in: 1...4)
        return Array(allSpecialties.shuffled().prefix(count))
    }
    
    private func generateRandomCertifications() -> [String] {
        let certifications = ["Organik Üretici Sertifikası", "HACCP", "ISO 22000", 
                            "Global GAP", "Türk Gıda Kodeksi", "Veteriner Hekim Raporu"]
        let count = Int.random(in: 0...3)
        return count == 0 ? [] : Array(certifications.shuffled().prefix(count))
    }
    
    private func generateFarmerBio(farmer: (name: String, phone: String, experience: String), city: String) -> String {
        let templates = [
            "\(city)'da \(farmer.experience) olan bir çiftçiyim. Kaliteli ürünler yetiştirmeye özen gösteriyorum.",
            "Aile işletmemizde \(farmer.experience) süreyle tarım yapıyoruz. Müşteri memnuniyeti önceliğimizdir.",
            "\(city) yöresinde \(farmer.experience) ile tarım sektöründeyim. Doğal ve taze ürünler sunuyorum.",
            "Geleneksel tarım yöntemleriyle modern teknikleri birleştirerek \(farmer.experience) boyunca üretim yapıyorum."
        ]
        return templates.randomElement()!
    }
}

// MARK: - Usage Extension
extension FirestoreMockDataGenerator {
    static func createSampleData() async {
        let generator = FirestoreMockDataGenerator()
        await generator.generateMockData()
    }
    
    // Belirli bir kategori için mock data
    static func createDataForCategory(_ categoryName: String, productCount: Int = 10) async {
        let generator = FirestoreMockDataGenerator()
        
        guard let category = generator.categoriesData.categories.first(where: { $0.name == categoryName }) else {
            print("❌ Kategori bulunamadı: \(categoryName)")
            return
        }
        
        print("🌱 \(categoryName) kategorisi için mock data oluşturuluyor...")
        
        var totalProducts = 0
        for subCategory in category.subCategories {
            for i in 0..<min(productCount / category.subCategories.count + 1, 3) {
                let mockProduct = generator.generateMockProduct(
                    category: category,
                    subCategory: subCategory,
                    index: i
                )
                await generator.saveMockProduct(mockProduct)
                totalProducts += 1
            }
        }
        
        print("🎉 \(categoryName) için \(totalProducts) ürün oluşturuldu!")
    }
    
    // Test amaçlı az veri oluşturma
    static func createTestData() async {
        let generator = FirestoreMockDataGenerator()
        
        print("🧪 Test verisi oluşturuluyor...")
        
        // Her kategoriden 1-2 ürün
        for category in generator.categoriesData.categories.prefix(5) {
            for subCategory in category.subCategories.prefix(2) {
                let mockProduct = generator.generateMockProduct(
                    category: category,
                    subCategory: subCategory,
                    index: 0
                )
                await generator.saveMockProduct(mockProduct)
            }
        }
        
        print("🎉 Test verisi oluşturuldu!")
    }
}
