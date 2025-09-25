//
//  FarmDetailView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/26/25.
//
import SwiftUI
import MapKit
import FirebaseFirestore

class FarmDetailViewModel: ObservableObject {
    private let db = Firestore.firestore()
    
    func toggleFarmStatus(_ farm: Farm) {
        guard let farmId = farm.id else { return }
        
        db.collection("farms").document(farmId).updateData([
            "isActive": !farm.isActive,
            "updatedAt": Date()
        ])
    }
}

struct FarmDetailView: View {
    let farm: Farm
    let onUpdate: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = FarmDetailViewModel()
    @State private var showingEditSheet = false
    @State private var selectedImageIndex = 0
    @State private var showingImageViewer = false
    @State private var region: MKCoordinateRegion
    
    init(farm: Farm, onUpdate: @escaping () -> Void) {
        self.farm = farm
        self.onUpdate = onUpdate
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: farm.location.latitude,
                longitude: farm.location.longitude
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Resim Galerisi
                imageGallerySection
                
                // İçerik
                VStack(alignment: .leading, spacing: 24) {
                    // Başlık ve Durum
                    headerSection
                    
                    Divider()
                    
                    // Tarım İstatistikleri
                    statisticsSection
                }
                .padding()
            }
        }
        .navigationTitle("Tarla Detayları")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        viewModel.toggleFarmStatus(farm)
                        onUpdate()
                    } label: {
                        Label(
                            farm.isActive ? "Pasife Al" : "Aktif Et",
                            systemImage: farm.isActive ? "pause.circle" : "play.circle"
                        )
                    }
                    
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label("Düzenle", systemImage: "pencil")
                    }
                    
                    Divider()
                    
                    Button(role: .destructive) {
                        // Silme işlemi
                    } label: {
                        Label("Sil", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingImageViewer) {
            ImageViewerSheet(images: farm.images, selectedIndex: $selectedImageIndex)
        }
    }
    
    // MARK: - Image Gallery Section
    private var imageGallerySection: some View {
        TabView(selection: $selectedImageIndex) {
            ForEach(0..<farm.images.count, id: \.self) { index in
                AsyncImage(url: URL(string: farm.images[index])) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.green.opacity(0.2)
                        .overlay {
                            ProgressView()
                        }
                }
                .frame(height: 300)
                .clipped()
                .tag(index)
                .onTapGesture {
                    showingImageViewer = true
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: 300)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(farm.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(farm.isActive ? Color.green : Color.gray)
                        .frame(width: 10, height: 10)
                    
                    Text(farm.isActive ? "Aktif" : "Pasif")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(farm.isActive ? .green : .gray)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(farm.isActive ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
                )
            }
            
            if !farm.description.isEmpty {
                Text(farm.description)
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
            }
        }
    }
    
    // MARK: - Basic Info Section
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Temel Bilgiler")
                .font(.headline)
            
            VStack(spacing: 12) {
                InfoRow(title: "location.fill", value: "Konum", icon: farm.locationName)
                InfoRow(title: "map.fill", value: "Adres", icon: farm.address)
                InfoRow(title: "square.grid.3x3", value: "Alan", icon: farm.formattedArea)
                InfoRow(title: "circle.hexagongrid.fill", value: "Toprak Tipi", icon: farm.soilType)
                InfoRow(title: "drop.fill", value: "Sulama", icon: farm.irrigationType)
            }
        }
    }
    
    // MARK: - Features Section
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Altyapı & Özellikler")
                .font(.headline)
            
            HStack(spacing: 16) {
                FeatureCard(
                    icon: "drop.fill",
                    title: "Su Erişimi",
                    isAvailable: farm.hasWaterAccess,
                    color: .blue
                )
                
                FeatureCard(
                    icon: "bolt.fill",
                    title: "Elektrik",
                    isAvailable: farm.hasElectricity,
                    color: .orange
                )
            }
        }
    }
    
    // MARK: - Crops Section
    private var cropsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Yetiştirilen Ürünler")
                .font(.headline)
            
            if farm.crops.isEmpty {
                Text("Henüz ürün belirtilmemiş")
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                FlowLayout(spacing: 8) {
                    ForEach(farm.crops, id: \.self) { crop in
                        HStack(spacing: 4) {
                            Image(systemName: "leaf.fill")
                                .font(.caption2)
                            Text(crop)
                                .font(.subheadline)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .clipShape(Capsule())
                    }
                }
            }
        }
    }
    
    // MARK: - Certifications Section
    private var certificationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sertifikalar")
                .font(.headline)
            
            if farm.certifications.isEmpty {
                Text("Sertifika bulunmuyor")
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                VStack(spacing: 12) {
                    ForEach(farm.certifications, id: \.self) { cert in
                        HStack {
                            Image(systemName: getCertificationIcon(cert))
                                .foregroundColor(.green)
                            Text(cert)
                                .font(.subheadline)
                            Spacer()
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                        }
                        .padding()
                        .background(Color.green.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }
    
    // MARK: - Map Section
    private var mapSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Konum")
                .font(.headline)
            
            Map(coordinateRegion: .constant(region), annotationItems: [farm]) { farm in
                MapMarker(
                    coordinate: CLLocationCoordinate2D(
                        latitude: farm.location.latitude,
                        longitude: farm.location.longitude
                    ),
                    tint: .green
                )
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            
            Text("Koordinatlar: \(String(format: "%.6f, %.6f", farm.location.latitude, farm.location.longitude))")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Statistics Section
    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("İstatistikler")
                .font(.headline)
            
            HStack(spacing: 12) {
                StatCard(
                    title: "calendar",
                    value: "Oluşturma",
                    icon: farm.createdAt.formatted(date: .abbreviated, time: .omitted),
                    color: .blue
                )
                
                StatCard(
                    title: "arrow.triangle.2.circlepath",
                    value: "Son Güncelleme",
                    icon: farm.updatedAt.formatted(date: .abbreviated, time: .omitted),
                    color: .orange
                )
            }
        }
    }
    
    private func getCertificationIcon(_ certification: String) -> String {
        if let cert = FarmCertification.allCases.first(where: { $0.rawValue == certification }) {
            return cert.icon
        }
        return "checkmark.seal.fill"
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let isAvailable: Bool
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(isAvailable ? color : .gray)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
            
            Text(isAvailable ? "Mevcut" : "Yok")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isAvailable ? color.opacity(0.1) : Color.gray.opacity(0.05))
        )
    }
}
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                
                frames.append(CGRect(origin: CGPoint(x: x, y: y), size: size))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

struct ImageViewerSheet: View {
    let images: [String]
    @Binding var selectedIndex: Int
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedIndex) {
                ForEach(0..<images.count, id: \.self) { index in
                    AsyncImage(url: URL(string: images[index])) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .navigationTitle("Resim \(selectedIndex + 1) / \(images.count)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
            }
        }
    }
}
