//
//  NotificationView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//

import SwiftUI

struct NotificationSettingView: View {
    @State private var notificationSettings = NotificationSettings()
    
    var body: some View {
        NavigationView {
            List {
                // Genel Ayarlar
                Section(header: Text("Genel Ayarlar")) {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.green)
                            .frame(width: 24, height: 24)
                        
                        VStack(alignment: .leading) {
                            Text("Tüm Bildirimler")
                                .font(.headline)
                            Text("Uygulamadan gelen tüm bildirimleri kontrol et")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $notificationSettings.allNotifications)
                            .onChange(of: notificationSettings.allNotifications) { oldValue,newValue in
                                if !newValue {
                                    notificationSettings.disableAll()
                                }
                            }
                    }
                    .padding(.vertical, 4)
                }
                
                // Tarım ve Üretim
                Section(header: Text("🌾 Tarım ve Üretim")) {
                    NotificationRow(
                        icon: "leaf.fill",
                        title: "Ekim Zamanı",
                        subtitle: "Mevsimine göre ekim hatırlatmaları",
                        isEnabled: $notificationSettings.farmingAndProduction.plantingTime,
                        masterToggle: notificationSettings.allNotifications
                    )
                    
                    NotificationRow(
                        icon: "drop.fill",
                        title: "Sulama Hatırlatması",
                        subtitle: "Düzenli sulama zamanları",
                        isEnabled: $notificationSettings.farmingAndProduction.irrigation,
                        masterToggle: notificationSettings.allNotifications
                    )
                    
                    NotificationRow(
                        icon: "sun.max.fill",
                        title: "Hasat Zamanı",
                        subtitle: "Ürünlerin hasat edilme zamanı",
                        isEnabled: $notificationSettings.farmingAndProduction.harvestTime,
                        masterToggle: notificationSettings.allNotifications
                    )
                    
                    NotificationRow(
                        icon: "thermometer",
                        title: "Hava Durumu Uyarıları",
                        subtitle: "Tarım için önemli hava durumu değişiklikleri",
                        isEnabled: $notificationSettings.farmingAndProduction.weatherAlerts,
                        masterToggle: notificationSettings.allNotifications
                    )
                    
                    NotificationRow(
                        icon: "ant.fill",
                        title: "Hastalık ve Zararlı Uyarıları",
                        subtitle: "Bitki sağlığı ve koruma önerileri",
                        isEnabled: $notificationSettings.farmingAndProduction.pestAlerts,
                        masterToggle: notificationSettings.allNotifications
                    )
                }
                
                // Market ve Fiyat
                Section(header: Text("💰 Market ve Fiyat")) {
                    NotificationRow(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Fiyat Değişimleri",
                        subtitle: "Ürün fiyatlarındaki değişiklikler",
                        isEnabled: $notificationSettings.marketAndPrice.priceChanges,
                        masterToggle: notificationSettings.allNotifications
                    )
                    
                    NotificationRow(
                        icon: "tag.fill",
                        title: "En İyi Satış Zamanı",
                        subtitle: "Ürünlerinizi satmak için ideal zamanlar",
                        isEnabled: $notificationSettings.marketAndPrice.bestSellingTime,
                        masterToggle: notificationSettings.allNotifications
                    )
                    
                    NotificationRow(
                        icon: "storefront.fill",
                        title: "Pazar Günleri",
                        subtitle: "Yerel pazar ve fuar bildirimleri",
                        isEnabled: $notificationSettings.marketAndPrice.marketDays,
                        masterToggle: notificationSettings.allNotifications
                    )
                    
                    NotificationRow(
                        icon: "truck.box.fill",
                        title: "Toptan Alıcı Talepleri",
                        subtitle: "Büyük miktarda ürün talep eden alıcılar",
                        isEnabled: $notificationSettings.marketAndPrice.wholesaleBuyers,
                        masterToggle: notificationSettings.allNotifications
                    )
                }
                
                // Gıda ve Beslenme
                Section(header: Text("🥬 Gıda ve Beslenme")) {
                    NotificationRow(
                        icon: "timer",
                        title: "Son Kullanma Tarihi",
                        subtitle: "Ürünlerin bozulma tarihi yaklaştığında",
                        isEnabled: $notificationSettings.foodAndNutrition.expiryDate,
                        masterToggle: notificationSettings.allNotifications
                    )
                    
                    NotificationRow(
                        icon: "heart.fill",
                        title: "Beslenme Önerileri",
                        subtitle: "Mevsimlik sağlıklı beslenme tavsiyeleri",
                        isEnabled: $notificationSettings.foodAndNutrition.nutritionTips,
                        masterToggle: notificationSettings.allNotifications
                    )
                    
                    NotificationRow(
                        icon: "book.closed.fill",
                        title: "Tarif Önerileri",
                        subtitle: "Mevsim ürünleriyle yapılabilecek tarifler",
                        isEnabled: $notificationSettings.foodAndNutrition.recipeRecommendations,
                        masterToggle: notificationSettings.allNotifications
                    )
                    
                    NotificationRow(
                        icon: "leaf.arrow.circlepath",
                        title: "Organik Ürün Bildirimleri",
                        subtitle: "Yeni organik ürün ve sertifika haberleri",
                        isEnabled: $notificationSettings.foodAndNutrition.organicProducts,
                        masterToggle: notificationSettings.allNotifications
                    )
                }
                
                // Sosyal ve Eğitim
                Section(header: Text("👥 Sosyal ve Eğitim")) {
                    NotificationRow(
                        icon: "graduationcap.fill",
                        title: "Eğitim ve Kurslar",
                        subtitle: "Tarım teknikleri ve eğitim fırsatları",
                        isEnabled: $notificationSettings.socialAndEducation.courses,
                        masterToggle: notificationSettings.allNotifications
                    )
                    
                    NotificationRow(
                        icon: "person.2.fill",
                        title: "Çiftçi Buluşmaları",
                        subtitle: "Yerel çiftçi toplantı ve etkinlikleri",
                        isEnabled: $notificationSettings.socialAndEducation.farmerMeetings,
                        masterToggle: notificationSettings.allNotifications
                    )
                    
                    NotificationRow(
                        icon: "newspaper.fill",
                        title: "Tarım Haberleri",
                        subtitle: "Sektörel gelişmeler ve yenilikler",
                        isEnabled: $notificationSettings.socialAndEducation.agricultureNews,
                        masterToggle: notificationSettings.allNotifications
                    )
                    
                    NotificationRow(
                        icon: "hands.sparkles.fill",
                        title: "Destek ve Hibe Programları",
                        subtitle: "Devlet destekleri ve hibe fırsatları",
                        isEnabled: $notificationSettings.socialAndEducation.supportPrograms,
                        masterToggle: notificationSettings.allNotifications
                    )
                }
                
                // Teknoloji ve İnovasyon
                Section(header: Text("⚡ Teknoloji ve İnovasyon")) {
                    NotificationRow(
                        icon: "sensor.fill",
                        title: "Akıllı Tarım Sensörleri",
                        subtitle: "IoT cihaz bildirimleri ve uyarıları",
                        isEnabled: $notificationSettings.technologyAndInnovation.smartSensors,
                        masterToggle: notificationSettings.allNotifications
                    )
                    
                    NotificationRow(
                        icon: "gear.badge",
                        title: "Ekipman Bakımı",
                        subtitle: "Tarım araçları bakım hatırlatmaları",
                        isEnabled: $notificationSettings.technologyAndInnovation.equipmentMaintenance,
                        masterToggle: notificationSettings.allNotifications
                    )
                    
                    NotificationRow(
                        icon: "app.badge.fill",
                        title: "Uygulama Güncellemeleri",
                        subtitle: "Yeni özellikler ve güncelleme bildirimleri",
                        isEnabled: $notificationSettings.technologyAndInnovation.appUpdates,
                        masterToggle: notificationSettings.allNotifications
                    )
                    
                    NotificationRow(
                        icon: "brain.head.profile",
                        title: "AI Önerileri",
                        subtitle: "Yapay zeka destekli tarım önerileri",
                        isEnabled: $notificationSettings.technologyAndInnovation.aiRecommendations,
                        masterToggle: notificationSettings.allNotifications
                    )
                }
            }
            .navigationTitle("Bildirim Ayarları")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

struct NotificationRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isEnabled: Bool
    let masterToggle: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isEnabled && masterToggle ? .green : .gray)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(masterToggle ? .primary : .gray)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .disabled(!masterToggle)
        }
        .padding(.vertical, 4)
        .opacity(masterToggle ? 1.0 : 0.6)
    }
}

// MARK: - Data Models
struct NotificationSettings {
    var allNotifications: Bool = true
    
    var farmingAndProduction = FarmingAndProductionSettings()
    var marketAndPrice = MarketAndPriceSettings()
    var foodAndNutrition = FoodAndNutritionSettings()
    var socialAndEducation = SocialAndEducationSettings()
    var technologyAndInnovation = TechnologyAndInnovationSettings()
    
    mutating func disableAll() {
        farmingAndProduction.disableAll()
        marketAndPrice.disableAll()
        foodAndNutrition.disableAll()
        socialAndEducation.disableAll()
        technologyAndInnovation.disableAll()
    }
}

struct FarmingAndProductionSettings {
    var plantingTime: Bool = true
    var irrigation: Bool = true
    var harvestTime: Bool = true
    var weatherAlerts: Bool = true
    var pestAlerts: Bool = true
    
    mutating func disableAll() {
        plantingTime = false
        irrigation = false
        harvestTime = false
        weatherAlerts = false
        pestAlerts = false
    }
}

struct MarketAndPriceSettings {
    var priceChanges: Bool = true
    var bestSellingTime: Bool = true
    var marketDays: Bool = true
    var wholesaleBuyers: Bool = true
    
    mutating func disableAll() {
        priceChanges = false
        bestSellingTime = false
        marketDays = false
        wholesaleBuyers = false
    }
}

struct FoodAndNutritionSettings {
    var expiryDate: Bool = true
    var nutritionTips: Bool = true
    var recipeRecommendations: Bool = true
    var organicProducts: Bool = true
    
    mutating func disableAll() {
        expiryDate = false
        nutritionTips = false
        recipeRecommendations = false
        organicProducts = false
    }
}

struct SocialAndEducationSettings {
    var courses: Bool = true
    var farmerMeetings: Bool = true
    var agricultureNews: Bool = true
    var supportPrograms: Bool = true
    
    mutating func disableAll() {
        courses = false
        farmerMeetings = false
        agricultureNews = false
        supportPrograms = false
    }
}

struct TechnologyAndInnovationSettings {
    var smartSensors: Bool = true
    var equipmentMaintenance: Bool = true
    var appUpdates: Bool = true
    var aiRecommendations: Bool = true
    
    mutating func disableAll() {
        smartSensors = false
        equipmentMaintenance = false
        appUpdates = false
        aiRecommendations = false
    }
}
