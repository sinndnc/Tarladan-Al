//
//  AccountView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var languageManager: LanguageManager
    
    @EnvironmentObject private var accountViewModel : AccountViewModel
    
    var body: some View {
        NavigationStack {
            List{
                Section {
                    profileHeaderView
                }
                .listRowBackground(Color.clear)
                
                Section("Bu Ay"){
                    quickStatsView
                }
                .listRowBackground(Color.clear)
                
                // Account Section
                Section("Hesap") {
                    NavigationMenuRow(
                        icon: "person.crop.circle",
                        title: "Kişisel Bilgiler",
                        color: .blue,
                        destination: .personalInfo
                    )
                    
                    NavigationMenuRow(
                        icon: "location.fill",
                        title: "Adreslerim",
                        color: .green,
                        destination: .addresses
                    )
                    
                    NavigationMenuRow(
                        icon: "creditcard.fill",
                        title: "Ödeme Yöntemleri",
                        color: .purple,
                        destination: .paymentMethods
                    )
                }
                
                // Orders Section
                Section("Siparişler") {
                    NavigationMenuRow(
                        icon: "clock.arrow.circlepath",
                        title: "Sipariş Geçmişi",
                        color: .orange,
                        destination: .orderHistory
                    )
                    
                    NavigationMenuRow(
                        icon: "heart.text.square",
                        title: "Favorilerim",
                        color: .red,
                        destination: .favorites
                    )
                    
                    NavigationMenuRow(
                        icon: "star.fill",
                        title: "Değerlendirmelerim",
                        color: .yellow,
                        destination: .reviews
                    )
                }
                
                // App Settings Section
                Section("Uygulama") {
                    NavigationMenuRow(
                        icon: "bell.fill",
                        title: "Bildirimler",
                        color: .blue,
                        destination: .notifications
                    )
                    
                    Menu{
                        ForEach(Theme.allCases,id:\.self){ theme in
                            Button(theme.displayName){
                                themeManager.setTheme(theme)
                            }
                        }
                    } label: {
                        HStack(spacing: 15){
                            Image(systemName: "moon.fill")
                                .font(.title3)
                                .foregroundColor(.indigo)
                                .frame(width: 25)
                            
                            Text("Görünüm Modu")
                                .font(.body)
                            
                            Spacer()
                            
                            HStack(spacing: 3){
                                Text(themeManager.currentTheme.displayName)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Image(systemName: "chevron.down")
                                    .font(.subheadline)
                                    .foregroundColor(Color(.systemGray))
                            }
                        }
                    }
                    .tint(.primary)
                    
                    NavigationMenuRow(
                        icon: "globe",
                        title: "Dil",
                        color: .green,
                        destination: .language,
                        rightContent: {
                            Text(languageManager.currentLanguage.displayName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    )
                }
                
                
                // Support Section
                Section("Destek") {
                    NavigationMenuRow(
                        icon: "questionmark.circle",
                        title: "Yardım Merkezi",
                        color: .blue,
                        destination: .helpCenter
                    )
                    
                    NavigationMenuRow(
                        icon: "message.fill",
                        title: "Bize Ulaşın",
                        color: .green,
                        destination: .contactSupport
                    )
                    
                    HStack(spacing: 15) {
                        Image(systemName: "star.bubble")
                            .font(.title3)
                            .foregroundColor(.yellow)
                            .frame(width: 25)
                        
                        Text("Uygulamayı Değerlendir")
                            .font(.body)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .contentShape(Rectangle())
                   
                }
                
                // Sustainability Score Section
                Section {
                    sustainabilityScoreView
                } header: {
                    Text("Sürdürülebilirlik Skorun")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .textCase(nil)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                
                
                
                // Logout Section
                Section {
                    Button{
                        
                    }label:{
                        HStack(spacing: 15) {
                            Image(systemName: "arrow.right.square")
                                .font(.title3)
                                .foregroundColor(.red)
                                .frame(width: 25)
                            
                            Text("Çıkış Yap")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.red)
                            
                            Spacer()
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Hesap")
            .scrollContentBackground(.hidden)
            .listStyle(InsetGroupedListStyle())
            .background(Colors.System.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for:.navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Colors.UI.tabBackground, for: .navigationBar)
            .navigationDestination(for: AccountDestination.self) { destination in
                destinationView(for: destination)
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for destination: AccountDestination) -> some View {
        switch destination {
        case .personalInfo:
            PersonInfoView()
        case .addresses:
            AddressesView()
        case .paymentMethods:
            PaymentsView()
        case .orderHistory:
            OrderHistoryView()
        case .favorites:
            FavoritesView()
        case .reviews:
            ReviewsView()
        case .helpCenter:
            HelpCenterView()
        case .contactSupport:
            ContactSupportView()
        case .language:
            LanguagesView()
        case .notifications:
            NotificationSettingView()
        }
    }
    
    private var profileHeaderView: some View {
        HStack(spacing: 20) {
            // Profile Image
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(LinearGradient(
                        colors: [Color.green.opacity(0.8), Color.green],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Text(String(accountViewModel.userProfile.name.prefix(2)).uppercased())
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(accountViewModel.userProfile.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(accountViewModel.userProfile.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                if accountViewModel.userProfile.isPremium {
                    Text("Premium Üye")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.15))
                        .cornerRadius(6)
                }
            }
        }
        .padding(5)
    }
    
    private var quickStatsView: some View {
        HStack(spacing: 0) {
            StatCardCompact(
                icon: "shippingbox.fill",
                title: "Teslimat",
                value: "\(accountViewModel.monthlyStats.deliveries)",
                subtitle: "kutu",
                color: .blue
            )
            
            Divider()
            
            StatCardCompact(
                icon: "leaf.fill",
                title: "CO² Tasarrufu",
                value: String(format: "%.1f", accountViewModel.monthlyStats.co2Savings),
                subtitle: "kg",
                color: .green
            )
            
            Divider()
            
            StatCardCompact(
                icon: "heart.fill",
                title: "Favori",
                value: "\(accountViewModel.monthlyStats.favoriteProducts)",
                subtitle: "ürün",
                color: .red
            )
        }
    }
    
    private var sustainabilityScoreView: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "leaf.fill")
                            .font(.title3)
                            .foregroundColor(.green)
                        
                        Text("Çevre Dostu Seçimler")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    Text("Bu ay \(accountViewModel.sustainabilityScore.totalScore) puan topladın!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        let rating = accountViewModel.sustainabilityScore.rating
                        let fullStars = Int(rating)
                        let hasHalfStar = rating - Double(fullStars) >= 0.5
                        
                        ForEach(0..<5) { index in
                            Image(systemName: index < fullStars ? "star.fill" :
                                 (index == fullStars && hasHalfStar) ? "star.leadinghalf.filled" : "star")
                                .foregroundColor(.green)
                                .font(.caption)
                        }
                        
                        Text("\(String(format: "%.1f", rating))/5.0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("\(accountViewModel.sustainabilityScore.totalScore)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("puan")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(spacing: 12) {
                ProgressRowView(
                    title: "Organik Ürün Tercihi",
                    progress: accountViewModel.sustainabilityScore.organicPreference,
                    color: .green
                )
                ProgressRowView(
                    title: "Ambalaj Azaltımı",
                    progress: accountViewModel.sustainabilityScore.packagingReduction,
                    color: .blue
                )
                ProgressRowView(
                    title: "Yerel Üretici Desteği",
                    progress: accountViewModel.sustainabilityScore.localProducerSupport,
                    color: .orange
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.green.opacity(0.1))
        )
    }
}

#Preview {
    AccountView()
}
