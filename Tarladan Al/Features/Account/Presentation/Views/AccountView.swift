//
//  AccountView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI

struct AccountView: View {
    @StateObject private var viewModel = AccountViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    profileHeaderView
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                
                // Quick Stats Section
                Section {
                    quickStatsView
                } header: {
                    Text("Bu Ay")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .textCase(nil)
                } footer: {
                    Button(action: viewModel.showAllStats) {
                        Text("Tüm Tarihleri Gör")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                
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
                    HStack(spacing: 15) {
                        Image(systemName: "bell.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                            .frame(width: 25)
                        
                        Text("Bildirimler")
                            .font(.body)
                        
                        Spacer()
                        
                        Toggle("", isOn: Binding(
                            get: { viewModel.appSettings.notificationsEnabled },
                            set: { _ in viewModel.toggleNotifications() }
                        ))
                        .labelsHidden()
                    }
                    
                    HStack(spacing: 15) {
                        Image(systemName: "moon.fill")
                            .font(.title3)
                            .foregroundColor(.indigo)
                            .frame(width: 25)
                        
                        Text("Karanlık Mod")
                            .font(.body)
                        
                        Spacer()
                        
                        Toggle("", isOn: Binding(
                            get: { viewModel.appSettings.darkModeEnabled },
                            set: { _ in viewModel.toggleDarkMode() }
                        ))
                        .labelsHidden()
                    }
                    
                    NavigationMenuRow(
                        icon: "globe",
                        title: "Dil",
                        color: .green,
                        destination: .language,
                        rightContent: {
                            Text(viewModel.appSettings.language)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    )
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
                    .onTapGesture {
                        viewModel.rateApp()
                    }
                }
                
                // Logout Section
                Section {
                    Button(action: viewModel.logout) {
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
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Hesap")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Düzenle") {
                        viewModel.showEditProfile.toggle()
                    }
                    .font(.body)
                    .fontWeight(.medium)
                }
            }
            .refreshable {
                viewModel.refreshData()
            }
            .navigationDestination(for: AccountDestination.self) { destination in
                destinationView(for: destination)
            }
        }
        .sheet(isPresented: $viewModel.showEditProfile) {
            EditProfileView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.loadUserData()
        }
        .overlay {
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for destination: AccountDestination) -> some View {
        switch destination {
        case .personalInfo:
            PersonalInfoView()
        case .addresses:
            AddressesView()
        case .paymentMethods:
            PaymentMethodsView()
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
            LanguageSelectionView()
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
                        Text(String(viewModel.userProfile.name.prefix(2)).uppercased())
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                Button(action: viewModel.updateProfilePhoto) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        )
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.userProfile.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(viewModel.userProfile.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                if viewModel.userProfile.isPremium {
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        
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
        }
        .padding()
    }
    
    private var quickStatsView: some View {
        HStack(spacing: 0) {
            StatCardCompact(
                icon: "shippingbox.fill",
                title: "Teslimat",
                value: "\(viewModel.monthlyStats.deliveries)",
                subtitle: "kutu",
                color: .blue
            )
            
            Divider()
                .frame(height: 40)
            
            StatCardCompact(
                icon: "leaf.fill",
                title: "CO² Tasarrufu",
                value: String(format: "%.1f", viewModel.monthlyStats.co2Savings),
                subtitle: "kg",
                color: .green
            )
            
            Divider()
                .frame(height: 40)
            
            StatCardCompact(
                icon: "heart.fill",
                title: "Favori",
                value: "\(viewModel.monthlyStats.favoriteProducts)",
                subtitle: "ürün",
                color: .red
            )
        }
        .padding(.vertical, 16)
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
                    
                    Text("Bu ay \(viewModel.sustainabilityScore.totalScore) puan topladın!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        let rating = viewModel.sustainabilityScore.rating
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
                    Text("\(viewModel.sustainabilityScore.totalScore)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("puan")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(spacing: 12) {
                ProgressRow(
                    title: "Organik Ürün Tercihi",
                    progress: viewModel.sustainabilityScore.organicPreference,
                    color: .green
                )
                
                ProgressRow(
                    title: "Ambalaj Azaltımı",
                    progress: viewModel.sustainabilityScore.packagingReduction,
                    color: .blue
                )
                
                ProgressRow(
                    title: "Yerel Üretici Desteği",
                    progress: viewModel.sustainabilityScore.localProducerSupport,
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

// MARK: - Account Destinations Enum
enum AccountDestination: Hashable {
    case personalInfo
    case addresses
    case paymentMethods
    case orderHistory
    case favorites
    case reviews
    case helpCenter
    case contactSupport
    case language
}

// MARK: - Navigation Menu Row for List
struct NavigationMenuRow<RightContent: View>: View {
    let icon: String
    let title: String
    let color: Color
    let destination: AccountDestination
    let rightContent: (() -> RightContent)?
    
    init(icon: String, title: String, color: Color, destination: AccountDestination, rightContent: (() -> RightContent)? = nil) {
        self.icon = icon
        self.title = title
        self.color = color
        self.destination = destination
        self.rightContent = rightContent
    }
    
    var body: some View {
        NavigationLink(value: destination) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 25)
                
                Text(title)
                    .font(.body)
                
                Spacer()
                
                if let rightContent = rightContent {
                    rightContent()
                }
            }
        }
    }
}

// Extension for NavigationMenuRow without right content
extension NavigationMenuRow where RightContent == EmptyView {
    init(icon: String, title: String, color: Color, destination: AccountDestination) {
        self.icon = icon
        self.title = title
        self.color = color
        self.destination = destination
        self.rightContent = nil
    }
}

// MARK: - Compact Stat Card for List
struct StatCardCompact: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Progress Row
struct ProgressRow: View {
    let title: String
    let progress: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
        }
    }
}

// MARK: - Placeholder Destination Views
struct PersonalInfoView: View {
    var body: some View {
        List {
            Section("Kişisel Bilgiler") {
                HStack {
                    Text("Ad Soyad")
                    Spacer()
                    Text("Semih Duran")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("E-posta")
                    Spacer()
                    Text("semih@example.com")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Telefon")
                    Spacer()
                    Text("+90 555 123 45 67")
                        .foregroundColor(.secondary)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Kişisel Bilgiler")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressesView: View {
    var body: some View {
        List {
            Section("Kayıtlı Adreslerim") {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ev Adresi")
                        .font(.headline)
                    Text("Mimar Sinan Mah. Atatürk Cad. No:123")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("İş Adresi")
                        .font(.headline)
                    Text("Osmangazi Mah. İnönü Bulvarı No:456")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Adreslerim")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PaymentMethodsView: View {
    var body: some View {
        List {
            Section("Kayıtlı Kartlarım") {
                HStack {
                    Image(systemName: "creditcard.fill")
                        .foregroundColor(.blue)
                    VStack(alignment: .leading) {
                        Text("**** **** **** 1234")
                            .font(.headline)
                        Text("Visa")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Ödeme Yöntemleri")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OrderHistoryView: View {
    var body: some View {
        List {
            Section("Son Siparişlerim") {
                ForEach(0..<5) { index in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Sipariş #\(1000 + index)")
                                .font(.headline)
                            Spacer()
                            Text("Teslim Edildi")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.green)
                                .cornerRadius(4)
                        }
                        Text("3 ürün • ₺\((index + 1) * 50)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Sipariş Geçmişi")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FavoritesView: View {
    var body: some View {
        List {
            Section("Favori Ürünlerim") {
                ForEach(0..<3) { index in
                    HStack {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading) {
                            Text("Organik Domates \(index + 1)")
                                .font(.headline)
                            Text("₺\((index + 1) * 15)/kg")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Favorilerim")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReviewsView: View {
    var body: some View {
        List {
            Section("Değerlendirmelerim") {
                ForEach(0..<3) { index in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Organik Elma")
                            .font(.headline)
                        
                        HStack {
                            ForEach(0..<5) { star in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                            }
                            Text("5.0")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Çok taze ve lezzetliydi, kesinlikle tavsiye ederim!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Değerlendirmelerim")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HelpCenterView: View {
    var body: some View {
        List {
            Section("Sık Sorulan Sorular") {
                Text("Siparişim ne zaman gelir?")
                Text("İptal işlemi nasıl yapılır?")
                Text("Ödeme seçenekleri nelerdir?")
            }
            
            Section("Diğer") {
                Text("Kullanım Koşulları")
                Text("Gizlilik Politikası")
                Text("İletişim")
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Yardım Merkezi")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContactSupportView: View {
    var body: some View {
        List {
            Section("İletişim Bilgileri") {
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.green)
                    Text("0850 123 45 67")
                }
                
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.blue)
                    Text("destek@example.com")
                }
                
                HStack {
                    Image(systemName: "message.fill")
                        .foregroundColor(.purple)
                    Text("WhatsApp Destek")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Bize Ulaşın")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LanguageSelectionView: View {
    @State private var selectedLanguage = "Türkçe"
    let languages = ["Türkçe", "English", "العربية", "Español"]
    
    var body: some View {
        List {
            Section("Dil Seçimi") {
                ForEach(languages, id: \.self) { language in
                    HStack {
                        Text(language)
                        Spacer()
                        if language == selectedLanguage {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedLanguage = language
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Dil")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AccountViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section("Kişisel Bilgiler") {
                    HStack {
                        Text("Ad Soyad")
                        Spacer()
                        TextField("Ad Soyad", text: $viewModel.userProfile.name)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("E-posta")
                        Spacer()
                        TextField("E-posta", text: $viewModel.userProfile.email)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Telefon")
                        Spacer()
                        TextField("Telefon", text: $viewModel.userProfile.phone)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Profil Fotoğrafı") {
                    HStack(spacing: 15) {
                        Circle()
                            .fill(LinearGradient(
                                colors: [Color.green.opacity(0.8), Color.green],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text(String(viewModel.userProfile.name.prefix(2)).uppercased())
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Profil Fotoğrafı")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("Fotoğrafınızı değiştirin")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Değiştir") {
                            viewModel.updateProfilePhoto()
                        }
                        .foregroundColor(.blue)
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Profili Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        viewModel.updateProfile(
                            name: viewModel.userProfile.name,
                            email: viewModel.userProfile.email,
                            phone: viewModel.userProfile.phone
                        )
                        presentationMode.wrappedValue.dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(viewModel.isLoading)
                }
            }
        }
        .overlay {
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
    }
}

#Preview {
    AccountView()
}
