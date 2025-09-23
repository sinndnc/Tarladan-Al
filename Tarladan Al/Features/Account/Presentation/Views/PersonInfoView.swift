//
//  PersonalInfoView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//

import SwiftUI
// MARK: - Premium Person Info View
struct PersonInfoView: View {
    @State private var showingEditView = false
    @State private var showingImagePicker = false
    @State private var showingPhoneVerification = false
    @State private var showingEmailVerification = false
    
    @EnvironmentObject private var userViewModel: UserViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let user = userViewModel.user {
                    // Profile Header
                    profileHeaderSection(user: user)
                    
                    // Verification Status
                    verificationStatusSection(user: user)
                    
                    // Personal Info
                    personalInfoSection(user: user)
                    
                    // Account Stats
                    accountStatsSection(user: user)
                    
                    // Preferences
                    preferencesSection(user: user)
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(showingEditView ? "Tamam" : "Düzenle") {
                    showingEditView.toggle()
                }
                .fontWeight(.medium)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerView()
        }
        .sheet(isPresented: $showingPhoneVerification) {
            PhoneVerificationView()
        }
        .sheet(isPresented: $showingEmailVerification) {
            EmailVerificationView()
        }
    }
    
    private func profileHeaderSection(user: User) -> some View {
        VStack(spacing: 20) {
            Button {
                showingImagePicker = true
            } label: {
                ZStack {
                    if let profileImageUrl = user.profileImageUrl, !profileImageUrl.isEmpty {
                        AsyncImage(url: URL(string: profileImageUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Circle()
                                .fill(Color(.systemGray5))
                                .overlay(ProgressView())
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text("\(user.firstName.prefix(1))\(user.lastName.prefix(1))")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                    }
                    
                    // Edit Indicator
                    Circle()
                        .fill(Color(.systemBackground))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                        )
                        .offset(x: 30, y: 30)
                }
            }
            
            VStack(spacing: 8) {
                Text("\(user.firstName) \(user.lastName)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Membership Badge
                HStack(spacing: 4) {
                    Image(systemName: user.isLoyalCustomer ? "star.fill" : "person.fill")
                        .font(.caption)
                    Text(user.isLoyalCustomer ? "Premium Üye" : "Standart Üye")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundColor(user.isLoyalCustomer ? .orange : .blue)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background((user.isLoyalCustomer ? Color.orange : Color.blue).opacity(0.1))
                .clipShape(Capsule())
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
    
    private func verificationStatusSection(user: User) -> some View {
        HStack(spacing: 12) {
            VerificationBadge(
                title: "E-posta",
                isVerified: user.emailVerified,
                icon: "envelope",
                action: user.emailVerified ? nil : { showingEmailVerification = true }
            )
            
            VerificationBadge(
                title: "Telefon",
                isVerified: user.phoneVerified,
                icon: "phone",
                action: user.phoneVerified ? nil : { showingPhoneVerification = true }
            )
            
            VerificationBadge(
                title: "Hesap",
                isVerified: user.isActive,
                icon: "checkmark.shield",
                action: nil
            )
        }
    }
    
    private func personalInfoSection(user: User) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Kişisel Bilgiler")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                InfoRow(
                    title: "Ad Soyad",
                    value: "\(user.firstName) \(user.lastName)",
                    icon: "person.fill"
                )
                
                InfoRow(
                    title: "E-posta",
                    value: user.email,
                    icon: "envelope.fill",
                    isVerified: user.emailVerified
                )
                
                InfoRow(
                    title: "Telefon",
                    value: user.phone,
                    icon: "phone.fill",
                    isVerified: user.phoneVerified,
                    isEditable: showingEditView
                )
                
                InfoRow(
                    title: "Dil",
                    value: user.language,
                    icon: "globe"
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
    
    private func accountStatsSection(user: User) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hesap İstatistikleri")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 12) {
                StatCard(
                    title: "Toplam Sipariş",
                    value: "\(user.totalOrders)",
                    icon: "bag.fill",
                    color: .blue
                )
                
                StatCard(
                    title: "Harcama",
                    value: "₺\(user.totalSpent, default: "%.0f")",
                    icon: "creditcard.fill",
                    color: .green
                )
                
                StatCard(
                    title: "Puan",
                    value: "\(user.loyaltyPoints)",
                    icon: "star.fill",
                    color: .orange
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
    
    private func preferencesSection(user: User) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tercihler")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
}

// MARK: - Supporting Views
struct VerificationBadge: View {
    let title: String
    let isVerified: Bool
    let icon: String
    let action: (() -> Void)?
    
    var body: some View {
        Button {
            action?()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isVerified ? .green : .orange)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(isVerified ? "Doğrulandı" : "Beklemede")
                    .font(.caption2)
                    .foregroundColor(isVerified ? .green : .orange)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill((isVerified ? Color.green : Color.orange).opacity(0.1))
            )
        }
        .disabled(action == nil)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    let icon: String
    var isVerified: Bool? = nil
    var isEditable: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                if let isVerified = isVerified {
                    Image(systemName: isVerified ? "checkmark.circle.fill" : "clock.circle")
                        .font(.caption)
                        .foregroundColor(isVerified ? .green : .orange)
                }
                
                if isEditable {
                    Image(systemName: "pencil.circle")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

// MARK: - Modal Views (Simplified)
struct ImagePickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Profil fotoğrafı seçme özelliği yakında...")
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding()
            .navigationTitle("Fotoğraf Seç")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") { dismiss() }
                }
            }
        }
    }
}

struct PhoneVerificationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = userViewModel.user {
                    Text("SMS kodu gönderilecek:")
                        .foregroundColor(.secondary)
                    Text(user.phone)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Telefon Doğrula")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") { dismiss() }
                }
            }
        }
    }
}

struct EmailVerificationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = userViewModel.user {
                    Text("Doğrulama e-postası gönderilecek:")
                        .foregroundColor(.secondary)
                    Text(user.email)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("E-posta Doğrula")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") { dismiss() }
                }
            }
        }
    }
}
