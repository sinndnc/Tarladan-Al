//
//  MockDataGenerator.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/9/25.
//

import Foundation

class MockDataGenerator {
    
    static let turkishFirstNames = [
        "Ahmet", "Mehmet", "Mustafa", "Ali", "Hasan", "Hüseyin", "İbrahim", "İsmail", "Ömer", "Yusuf",
        "Fatma", "Ayşe", "Emine", "Hatice", "Zeynep", "Elif", "Meryem", "Seda", "Büşra", "Esra",
        "Can", "Ege", "Berk", "Eren", "Kaan", "Emre", "Deniz", "Onur", "Barış", "Tolga",
        "İrem", "Selin", "Dila", "Pınar", "Ceren", "Ece", "Begüm", "Gizem", "Merve", "Cansu"
    ]
    
    static let turkishLastNames = [
        "Yılmaz", "Kaya", "Demir", "Şahin", "Çelik", "Yıldız", "Yıldırım", "Öztürk", "Aydin", "Özdemir",
        "Arslan", "Doğan", "Kilic", "Aslan", "Çetin", "Kara", "Koç", "Kurt", "Özkan", "Şimşek",
        "Erdoğan", "Güneş", "Korkmaz", "Taş", "Aktaş", "Polat", "Karaca", "Mutlu", "Tunç", "Bulut",
        "Güler", "Türk", "Acar", "Keskin", "Çakır", "Ateş", "Özer", "Işık", "Bozkurt", "Köse"
    ]
    
    static let turkishCities = [
        "İstanbul", "Ankara", "İzmir", "Bursa", "Antalya", "Adana", "Konya", "Şanlıurfa", "Gaziantep", "Kocaeli",
        "Mersin", "Diyarbakır", "Hatay", "Manisa", "Kayseri", "Samsun", "Balıkesir", "Kahramanmaraş", "Van", "Aydın"
    ]
    
    static let profileImageUrls = [
        "https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=150",
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150",
        "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150",
        "https://images.unsplash.com/photo-1519244703995-f4e0f30006d5?w=150",
        "https://images.unsplash.com/photo-1506794778202-cad84cf45f21?w=150",
        "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150",
        "https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=150",
        "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150"
    ]
    
    static let companies = [
        "Teknoloji A.Ş.", "Bilişim Ltd.", "Yazılım Corp.", "Danışmanlık Hizmetleri",
        "E-ticaret Solutions", "Dijital Medya", "Fintech Türkiye", "Startup Hub"
    ]
    
    static let utmSources = [
        "google", "facebook", "instagram", "twitter", "linkedin", "email", "direct", "referral"
    ]
    
    static let utmCampaigns = [
        "organic_box_launch", "summer_fresh_produce", "healthy_living", "new_customer_discount",
        "refer_friend", "social_media_promo", "email_newsletter", "black_friday_special"
    ]
    
    // Product IDs for subscription box customization
    static let availableProductIDs = [
        1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, // Fruits
        2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, // Vegetables
        3001, 3002, 3003, 3004, 3005, 3006, 3007, 3008, 3009, 3010, // Herbs
        4001, 4002, 4003, 4004, 4005, 4006, 4007, 4008, 4009, 4010  // Specialty items
    ]
    
    static let commonAllergies = [
        "Fıstık", "Badem", "Ceviz", "Soya", "Gluten", "Süt", "Yumurta", "Balık", "Karides", "Susam"
    ]
    
    static let commonDislikes = [
        "Brokoli", "Karnabahar", "Patlıcan", "Kereviz", "Turp", "Pazı", "Roka", "Tere", "Maydanoz", "Dereotu"
    ]
    
    static func generateMockUsers(count: Int = 50) -> [User] {
        var users: [User] = []
        
        for i in 1...count {
            let user = User(
                id: UUID().uuidString,
                email: generateEmail(index: i),
                phone: generateTurkishPhone(),
                lastName: turkishLastNames.randomElement()!,
                firstName: turkishFirstNames.randomElement()!,
                profileImageUrl: Bool.random() ? profileImageUrls.randomElement() : nil,
                
                isActive: Double.random(in: 0...1) > 0.15, // 85% active (subscription business)
                isVerified: Double.random(in: 0...1) > 0.25, // 75% verified
                phoneVerified: Double.random(in: 0...1) > 0.35, // 65% phone verified
                emailVerified: Double.random(in: 0...1) > 0.15, // 85% email verified
                
                createdAt: generateRandomDate(daysAgo: Int.random(in: 1...365)),
                updatedAt: generateRandomDate(daysAgo: Int.random(in: 0...30)),
                lastLogin: Bool.random() ? generateRandomDate(daysAgo: Int.random(in: 0...7)) : nil,
                
                language: ["tr", "en"].randomElement()!,
                currency: ["TRY", "USD", "EUR"].randomElement()!,
                timeZone: ["Europe/Istanbul", "UTC", "Europe/London"].randomElement()!,
                newsletterOptIn: Double.random(in: 0...1) > 0.3, // 70% newsletter opt-in
                smsOptIn: Double.random(in: 0...1) > 0.6, // 40% SMS opt-in
                
                addresses: generateAddresses(),
                paymentMethods: generatePaymentMethods(),
                subscription: Double.random(in: 0...1) > 0.4 ? generateSubscription(id: i) : nil,
                
                dietaryPrefs: generateDietaryPreferences(),
                
                customerNotes: generateCustomerNotes(),
                loyaltyPoints: Int.random(in: 0...2500),
                referralCode: generateReferralCode(),
                
                totalOrders: Int.random(in: 0...24), // Max 2 years of monthly orders
                totalSpent: Double.random(in: 0...2000),
                averageOrder: Double.random(in: 29.99...79.99), // Based on box sizes
                lastOrderDate: Bool.random() ? generateRandomDate(daysAgo: Int.random(in: 0...30)) : nil,
                
                utmSource: Bool.random() ? utmSources.randomElement() : nil,
                utmCampaign: Bool.random() ? utmCampaigns.randomElement() : nil,
                referredBy: Bool.random() ? Int.random(in: 1000...9999) : nil
            )
            users.append(user)
        }
        
        return users
    }
    
    private static func generateEmail(index: Int) -> String {
        let domains = ["gmail.com", "hotmail.com", "outlook.com", "yahoo.com", "icloud.com", "yandex.com"]
        let firstName = turkishFirstNames.randomElement()!.lowercased()
        let lastName = turkishLastNames.randomElement()!.lowercased()
        let domain = domains.randomElement()!
        
        let variations = [
            "\(firstName).\(lastName)@\(domain)",
            "\(firstName)\(lastName)@\(domain)",
            "\(firstName)_\(lastName)@\(domain)",
            "\(firstName)\(index)@\(domain)"
        ]
        
        return variations.randomElement()!
    }
    
    private static func generateTurkishPhone() -> String {
        let operators = ["532", "533", "534", "535", "536", "537", "538", "539", "505", "506", "507", "508", "509"]
        let `operator` = operators.randomElement()!
        let number = String(format: "%07d", Int.random(in: 1000000...9999999))
        return "+90\(`operator`)\(number)"
    }
    
    private static func generateRandomDate(daysAgo: Int) -> Date {
        let now = Date()
        let timeInterval = TimeInterval(-daysAgo * 24 * 60 * 60)
        return now.addingTimeInterval(timeInterval)
    }
    
    private static func generateAddresses() -> [Address] {
        let count = Int.random(in: 1...3) // At least 1 address for delivery
        var addresses: [Address] = []
        
        for i in 0..<count {
            let address = Address(
                title: ["Ev Adresi", "İş Adresi", "Tatil Evi"].randomElement()!,
                fullAddress: "\(turkishCities.randomElement()!) Mahallesi, \(Int.random(in: 1...50)). Sokak No: \(Int.random(in: 1...200))",
                city: turkishCities.randomElement()!,
                district: turkishCities.randomElement()!,
                isDefault: i == 0
            )
            addresses.append(address)
        }
        
        return addresses
    }
    
    private static func generateSubscription(id: Int) -> Subscription {
        let boxSize = Subscription.BoxSize.allCases.randomElement()!
        let frequency = Subscription.DeliveryFrequency.allCases.randomElement()!
        let deliveryDay = Subscription.DeliveryDay.allCases.randomElement()!
        let isActive = Double.random(in: 0...1) > 0.2 // 80% active subscriptions
        
        // Calculate next delivery based on frequency
        let daysUntilNext = Int.random(in: 1...10)
        let nextDelivery = Calendar.current.date(byAdding: .day, value: daysUntilNext, to: Date()) ?? Date()
        
        // Some subscriptions might be paused
        let pausedUntil: Date? = !isActive && Bool.random() ?
            Calendar.current.date(byAdding: .day, value: Int.random(in: 7...30), to: Date()) : nil
        
        // Generate custom product preferences
        let customProductCount = Int.random(in: 0...8)
        let customProducts = Array(availableProductIDs.shuffled().prefix(customProductCount))
        
        return Subscription(
            id: id,
            boxSize: boxSize,
            frequency: frequency,
            deliveryDay: deliveryDay,
            isActive: isActive,
            nextDelivery: nextDelivery,
            pausedUntil: pausedUntil,
            customProducts: customProducts
        )
    }
    
    private static func generatePaymentMethods() -> [PaymentMethod] {
        let count = Int.random(in: 1...2) // Subscription users need at least 1 payment method
        var methods: [PaymentMethod] = []
        
        for i in 0..<count {
            let type = PaymentMethod.PaymentType.allCases.randomElement()!
            let method = PaymentMethod(
                id: Int.random(in: 1000...9999),
                type: type,
                lastFour: String(format: "%04d", Int.random(in: 1000...9999)),
                expiryMonth: Int.random(in: 1...12),
                expiryYear: Int.random(in: 2024...2030),
                cardHolderName: "\(turkishFirstNames.randomElement()!) \(turkishLastNames.randomElement()!)",
                isDefault: i == 0,
                tokenID: generateSecureToken()
            )
            methods.append(method)
        }
        
        return methods
    }
    
    private static func generateDietaryPreferences() -> DietaryPreference {
        let allergies = commonAllergies.shuffled().prefix(Int.random(in: 0...3))
        let dislikes = commonDislikes.shuffled().prefix(Int.random(in: 0...4))
        
        // Some preferences are more common than others
        let vegetarian = Double.random(in: 0...1) > 0.85 // 15% vegetarian
        let vegan = vegetarian && Double.random(in: 0...1) > 0.7 // 30% of vegetarians are vegan
        let glutenFree = Double.random(in: 0...1) > 0.9 // 10% gluten free
        let dairyFree = vegan || Double.random(in: 0...1) > 0.88 // Vegans + 12% others
        let nutFree = Double.random(in: 0...1) > 0.95 // 5% nut free
        let organic = Double.random(in: 0...1) > 0.3 // 70% prefer organic
        let localProduce = Double.random(in: 0...1) > 0.2 // 80% prefer local
        
        return DietaryPreference(
            vegetarian: vegetarian,
            vegan: vegan,
            glutenFree: glutenFree,
            dairyFree: dairyFree,
            nutFree: nutFree,
            organic: organic,
            localProduce: localProduce,
            allergies: Array(allergies),
            dislikes: Array(dislikes)
        )
    }
    
    private static func generateCustomerNotes() -> String {
        let notes = [
            "Organik ürünleri tercih ediyor, yerel üreticileri destekliyor",
            "Teslimat saatinde hassas, önceden SMS göndermek gerekiyor",
            "Seasonal kutularda çeşitlilik istiyor",
            "Küçük çocuklar var, pestisit-free ürünler önemli",
            "Vegan yaşam tarzı, hayvansal ürünlere dikkat edilmeli",
            "Gluten hassasiyeti var, çapraz kontaminasyona dikkat",
            "Subscription'ı hedge olarak kullanıyor, fiyat değişikliklerinde bilgilendirme yapılmalı",
            "Referral programına aktif katılıyor, arkadaşlarını çok öneriyor",
            "Feedback vermeyi seviyor, ürün önerilerinde bulunuyor",
            "Sustainability konusunda bilinçli, packaging'e dikkat ediyor",
            ""
        ]
        return notes.randomElement()!
    }
    
    private static func generateReferralCode() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numbers = "0123456789"
        
        var code = ""
        for _ in 0..<3 {
            code += String(letters.randomElement()!)
        }
        for _ in 0..<3 {
            code += String(numbers.randomElement()!)
        }
        return code
    }
    
    private static func generateSecureToken() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        return String((0..<32).map { _ in characters.randomElement()! })
    }
}

import FirebaseFirestore

// MARK: - Firebase Upload Helper
class FirebaseDataUploader {
    private let db = Firestore.firestore()
    
    func uploadMockUsers(users: [User], completion: @escaping (Result<Void, Error>) -> Void) {
        let batch = db.batch()
        
        for user in users {
            let userRef = db.collection("users").document(user.id ?? "")
            
            do {
                let userData = try Firestore.Encoder().encode(user)
                batch.setData(userData, forDocument: userRef)
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        batch.commit { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func uploadSingleUser(_ user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let userData = try Firestore.Encoder().encode(user)
            db.collection("users").document(user.id ?? "").setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}

// MARK: - Usage Example
class MockDataService {
    private let uploader = FirebaseDataUploader()
    
    func generateAndUploadMockData(userCount: Int = 50) {
        let mockUsers = MockDataGenerator.generateMockUsers(count: userCount)
        
        print("🔄 \(mockUsers.count) kullanıcı Firebase'e yükleniyor...")
        
        uploader.uploadMockUsers(users: mockUsers) { result in
            switch result {
            case .success:
                print("✅ \(mockUsers.count) kullanıcı başarıyla Firebase'e yüklendi!")
                self.printDataSummary(users: mockUsers)
            case .failure(let error):
                print("❌ Firebase upload hatası: \(error.localizedDescription)")
            }
        }
    }
    
    private func printDataSummary(users: [User]) {
        let activeUsers = users.filter { $0.isActive }.count
        let verifiedUsers = users.filter { $0.isVerified }.count
        let subscribedUsers = users.filter { $0.subscription != nil }.count
        let totalSpent = users.reduce(0) { $0 + $1.totalSpent }
        
        print("""
        📊 Mock Data Özeti:
        • Toplam Kullanıcı: \(users.count)
        • Aktif Kullanıcı: \(activeUsers)
        • Doğrulanmış Kullanıcı: \(verifiedUsers)
        • Aboneli Kullanıcı: \(subscribedUsers)
        • Toplam Harcama: ₺\(String(format: "%.2f", totalSpent))
        """)
    }
}
