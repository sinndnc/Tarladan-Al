//
//  PersonalInfoView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//

import SwiftUI
// MARK: - Personal Info View
struct PersonalInfoView: View {
  
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
                    ProfileHeaderView(
                        user: user,
                        onImageTap: {
                            showingImagePicker = true
                        }
                    )
                    
                    // Account Status
                    AccountStatusView(user: user)
                    
                    Divider()
                    
                    // Personal Information
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeaderView(title: "Kişisel Bilgiler")
                        
                        VStack(spacing: 12) {
                            PersonalInfoRow(
                                title: "Ad",
                                value: user.firstName,
                                icon: "person.fill",
                                isEditable: false
                            )
                            
                            PersonalInfoRow(
                                title: "Soyad",
                                value: user.lastName,
                                icon: "person.fill",
                                isEditable: false
                            )
                            
                            PersonalInfoRow(
                                title: "E-posta",
                                value: user.email,
                                icon: "envelope.fill",
                                isVerified: user.emailVerified,
                                onVerifyTap: user.emailVerified ? nil : {
                                    showingEmailVerification = true
                                }
                            )
                            
                            PersonalInfoRow(
                                title: "Telefon",
                                value: user.phone,
                                icon: "phone.fill",
                                isVerified: user.phoneVerified,
                                isEditable: true,
                                onVerifyTap: user.phoneVerified ? nil : {
                                    showingPhoneVerification = true
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // Account Settings
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeaderView(title: "Hesap Ayarları")
                        
                        VStack(spacing: 12) {
                            SettingsRow(
                                title: "Hesap Durumu",
                                value: user.isActive ? "Aktif" : "Pasif",
                                icon: user.isActive ? "checkmark.circle.fill" : "xmark.circle.fill",
                                iconColor: user.isActive ? .green : .red
                            )
                            
                            SettingsRow(
                                title: "Doğrulama Durumu",
                                value: user.isVerified ? "Doğrulanmış" : "Doğrulanmamış",
                                icon: user.isVerified ? "shield.checkered" : "shield",
                                iconColor: user.isVerified ? .blue : .orange
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 30)
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Bilgileri Düzenle")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            // Şifre değiştir
                        }) {
                            HStack {
                                Image(systemName: "key")
                                Text("Şifre Değiştir")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Kişisel Bilgiler")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingEditView) {
                EditPersonalInfoView()
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
    }
}

// MARK: - Profile Header View
struct ProfileHeaderView: View {
    let user: User
    let onImageTap: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: onImageTap) {
                ZStack {
                    if let profileImageUrl = user.profileImageUrl, !profileImageUrl.isEmpty {
                        AsyncImage(url: URL(string: profileImageUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    ProgressView()
                                )
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 120, height: 120)
                            .overlay(
                                Text(user.firstName.prefix(1) + user.lastName.prefix(1))
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            )
                    }
                    
                    // Camera Icon
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "camera.fill")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                                .offset(x: -10, y: -10)
                        }
                    }
                    .frame(width: 120, height: 120)
                }
            }
            
            VStack(spacing: 4) {
                Text(user.fullName)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

// MARK: - Account Status View
struct AccountStatusView: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 16) {
            StatusBadge(
                title: "E-posta",
                isVerified: user.emailVerified,
                icon: "envelope"
            )
            
            StatusBadge(
                title: "Telefon",
                isVerified: user.phoneVerified,
                icon: "phone"
            )
            
            StatusBadge(
                title: "Hesap",
                isVerified: user.isActive,
                icon: "person"
            )
        }
        .padding(.horizontal)
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let title: String
    let isVerified: Bool
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(isVerified ? .green : .orange)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(isVerified ? "Doğrulanmış" : "Beklemede")
                .font(.caption2)
                .foregroundColor(isVerified ? .green : .orange)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background((isVerified ? Color.green : Color.orange).opacity(0.1))
                .cornerRadius(4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - Section Header View
struct SectionHeaderView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
    }
}

// MARK: - Personal Info Row
struct PersonalInfoRow: View {
    let title: String
    let value: String
    let icon: String
    var isVerified: Bool? = nil
    var isEditable: Bool = false
    var onVerifyTap: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 20)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let isVerified = isVerified {
                    if isVerified {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                    } else if let onVerifyTap = onVerifyTap {
                        Button("Doğrula") {
                            onVerifyTap()
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
                
                if isEditable {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
            }
            
            Text(value)
                .font(.body)
                .padding(.leading, 28)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    let title: String
    let value: String
    let icon: String
    let iconColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 20)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            Text(value)
                .font(.body)
                .padding(.leading, 28)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - Placeholder Views
struct EditPersonalInfoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userViewModel : UserViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Kişisel Bilgileri Düzenle")
                    .font(.title2)
                    .padding()
                
                // Form alanları burada olacak
                
                Spacer()
            }
            .navigationTitle("Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        // Save changes
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct ImagePickerView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Profil Fotoğrafı Seçin")
                    .font(.title2)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Fotoğraf Seç")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("İptal") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct PhoneVerificationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userViewModel : UserViewModel
    
    var body: some View {
        VStack {
            if let user = userViewModel.user{
                Text("Telefon Numarası Doğrulama")
                    .font(.title2)
                    .padding()
                
                Text("SMS kodu gönderilecek: \(user.phone)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
                
                Spacer()
            }
        }
        .navigationTitle("Telefon Doğrula")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("İptal") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct EmailVerificationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userViewModel : UserViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = userViewModel.user{
                    Text("E-posta Doğrulama")
                        .font(.title2)
                        .padding()
                    
                    Text("Doğrulama e-postası gönderilecek: \(user.email)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                    
                    Spacer()
                }
            }
            .navigationTitle("E-posta Doğrula")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct PersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInfoView()
    }
}
