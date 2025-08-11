//
//  EditProfileView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//
import SwiftUI

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
