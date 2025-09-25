//
//  FarmInfoView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/25/25.
//
import SwiftUI
import FirebaseFirestore
import MapKit

struct MyFarmsView: View {
    @StateObject private var viewModel = MyFarmsViewModel()
    @State private var showingAddFarm = false
    @State private var selectedFarm: Farm?
    @State private var showingDeleteAlert = false
    @State private var farmToDelete: Farm?
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Yükleniyor...")
            } else if viewModel.farms.isEmpty {
                emptyStateView
            } else {
                farmListView
            }
        }
        .navigationTitle("Tarlalarım")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddFarm = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                }
            }
        }
        .sheet(isPresented: $showingAddFarm) {
            AddFarmView {
                viewModel.fetchFarms()
            }
        }
        .sheet(item: $selectedFarm) { farm in
            FarmDetailView(farm: farm) {
                viewModel.fetchFarms()
            }
        }
        .alert("Tarlayı Sil", isPresented: $showingDeleteAlert) {
            Button("İptal", role: .cancel) { }
            Button("Sil", role: .destructive) {
                if let farm = farmToDelete {
                    viewModel.deleteFarm(farm)
                }
            }
        } message: {
            Text("Bu tarlayı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.")
        }
        .onAppear {
            viewModel.fetchFarms()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "map.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Henüz Tarla Yok")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tarlanızı ekleyerek başlayın")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button {
                showingAddFarm = true
            } label: {
                Label("Tarla Ekle", systemImage: "plus.circle.fill")
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
        .padding()
    }
    
    private var farmListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.farms) { farm in
                    FarmCardView(farm: farm)
                        .onTapGesture {
                            selectedFarm = farm
                        }
                        .contextMenu {
                            Button {
                                selectedFarm = farm
                            } label: {
                                Label("Detayları Gör", systemImage: "info.circle")
                            }
                            
                            Button {
                                viewModel.toggleFarmStatus(farm)
                            } label: {
                                Label(
                                    farm.isActive ? "Pasife Al" : "Aktif Et",
                                    systemImage: farm.isActive ? "pause.circle" : "play.circle"
                                )
                            }
                            
                            Button(role: .destructive) {
                                farmToDelete = farm
                                showingDeleteAlert = true
                            } label: {
                                Label("Sil", systemImage: "trash")
                            }
                        }
                }
            }
            .padding()
        }
    }
}

// MARK: - Farm Card View
struct FarmCardView: View {
    let farm: Farm
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Resim
            AsyncImage(url: URL(string: farm.mainImage)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.green.opacity(0.2)
                    .overlay {
                        Image(systemName: "map")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                    }
            }
            .frame(height: 180)
            .clipped()
            
            VStack(alignment: .leading, spacing: 12) {
                // Başlık ve Durum
                HStack {
                    Text(farm.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(farm.isActive ? Color.green : Color.gray)
                            .frame(width: 8, height: 8)
                        
                        Text(farm.isActive ? "Aktif" : "Pasif")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(farm.isActive ? .green : .gray)
                    }
                }
                
                // Konum
                Label(farm.locationName, systemImage: "location.fill")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                // Alan ve Toprak Tipi
                HStack(spacing: 16) {
                    Label(farm.formattedArea, systemImage: "square.grid.3x3")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Label(farm.soilType, systemImage: "circle.hexagongrid.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                // Ürünler
                if !farm.crops.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "leaf.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                        
                        Text(farm.cropsList)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                // Alt bilgiler
                HStack {
                    if farm.hasWaterAccess {
                        Label("Su", systemImage: "drop.fill")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                    
                    if farm.hasElectricity {
                        Label("Elektrik", systemImage: "bolt.fill")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                    
                    if !farm.certifications.isEmpty {
                        Label("\(farm.certifications.count) Sertifika", systemImage: "checkmark.seal.fill")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// MARK: - ViewModel
class MyFarmsViewModel: ObservableObject {
    @Published var farms: [Farm] = []
    @Published var isLoading = false
    
    private let db = Firestore.firestore()
    private let currentUserId = "current_user_id" // Gerçek kullanıcı ID'si
    
    func fetchFarms() {
        isLoading = true
        
        db.collection("farms")
            .whereField("farmerId", isEqualTo: currentUserId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    guard let documents = snapshot?.documents else {
                        print("Hata: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                        return
                    }
                    
                    self.farms = documents.compactMap { document in
                        try? document.data(as: Farm.self)
                    }
                }
            }
    }
    
    func toggleFarmStatus(_ farm: Farm) {
        guard let farmId = farm.id else { return }
        
        db.collection("farms").document(farmId).updateData([
            "isActive": !farm.isActive,
            "updatedAt": Date()
        ]) { error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteFarm(_ farm: Farm) {
        guard let farmId = farm.id else { return }
        
        db.collection("farms").document(farmId).delete() { error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
            }
        }
    }
}
