//
//  AddFarmView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/26/25.
//
import SwiftUI
import FirebaseFirestore
import PhotosUI
import MapKit

struct AddFarmView: View {
    let onSave: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddFarmViewModel()
    
    // Form Fields
    @State private var name = ""
    @State private var description = ""
    @State private var locationName = ""
    @State private var address = ""
    @State private var area = ""
    @State private var selectedAreaUnit = "dönüm"
    @State private var selectedSoilType = "Tınlı"
    @State private var selectedIrrigationType = "Damla Sulama"
    @State private var hasWaterAccess = false
    @State private var hasElectricity = false
    @State private var selectedCrops: Set<String> = []
    @State private var selectedCertifications: Set<String> = []
    @State private var customCrop = ""
    @State private var showingAddCrop = false
    
    // Location
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.9334, longitude: 32.8597),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    // Images
    @State private var selectedImages: [UIImage] = []
    @State private var showingImagePicker = false
    
    // Validation
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let commonCrops = ["Buğday", "Arpa", "Mısır", "Domates", "Biber", "Salatalık", "Patlıcan", "Üzüm", "Zeytin", "Çilek"]
    let certifications = ["Organik", "GAP (İyi Tarım Uygulamaları)", "GlobalGAP", "ISO 22000", "Helal Sertifikası", "Vegan Sertifikası"]
    
    var body: some View {
        Form {
            // Temel Bilgiler
            Section("Tarla Bilgileri") {
                TextField("Tarla Adı", text: $name)
                
                TextField("Açıklama", text: $description, axis: .vertical)
                    .lineLimit(3...6)
            }
            
            // Konum
            Section("Konum") {
                TextField("Konum Adı (örn: Ankara, Çankaya)", text: $locationName)
                
                TextField("Detaylı Adres", text: $address, axis: .vertical)
                    .lineLimit(2...4)
                
                Button {
                    getCurrentLocation()
                } label: {
                    Label("Mevcut Konumu Kullan", systemImage: "location.fill")
                        .foregroundColor(.green)
                }
                
                if latitude != 0.0 && longitude != 0.0 {
                    HStack {
                        Text("Koordinatlar:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(String(format: "%.6f, %.6f", latitude, longitude))
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }
            
            // Alan ve Özellikler
            Section("Tarla Özellikleri") {
                HStack {
                    TextField("Alan", text: $area)
                        .keyboardType(.decimalPad)
                    
                    Picker("", selection: $selectedAreaUnit) {
                        Text("dönüm").tag("dönüm")
                        Text("m²").tag("m²")
                        Text("hektar").tag("hektar")
                    }
                    .pickerStyle(.menu)
                }
                
                Picker("Toprak Tipi", selection: $selectedSoilType) {
                    Text("Kumlu").tag("Kumlu")
                    Text("Killi").tag("Killi")
                    Text("Tınlı").tag("Tınlı")
                    Text("Turbalı").tag("Turbalı")
                    Text("Kireçli").tag("Kireçli")
                    Text("Balçıklı").tag("Balçıklı")
                }
                
                Picker("Sulama Tipi", selection: $selectedIrrigationType) {
                    Text("Damla Sulama").tag("Damla Sulama")
                    Text("Yağmurlama").tag("Yağmurlama")
                    Text("Salma Sulama").tag("Salma Sulama")
                    Text("Yeraltı Sulama").tag("Yeraltı Sulama")
                    Text("Sulama Yok").tag("Sulama Yok")
                }
            }
            
            // Altyapı
            Section("Altyapı") {
                Toggle("Su Erişimi", isOn: $hasWaterAccess)
                Toggle("Elektrik", isOn: $hasElectricity)
            }
            
            // Yetiştirilen Ürünler
            Section {
                ForEach(Array(selectedCrops), id: \.self) { crop in
                    HStack {
                        Label(crop, systemImage: "leaf.fill")
                            .foregroundColor(.green)
                        Spacer()
                        Button {
                            selectedCrops.remove(crop)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Menu {
                    ForEach(commonCrops, id: \.self) { crop in
                        Button(crop) {
                            selectedCrops.insert(crop)
                        }
                    }
                    
                    Divider()
                    
                    Button("Özel Ürün Ekle...") {
                        showingAddCrop = true
                    }
                } label: {
                    Label("Ürün Ekle", systemImage: "plus.circle.fill")
                        .foregroundColor(.green)
                }
            } header: {
                Text("Yetiştirilen Ürünler")
            }
            
            // Sertifikalar
            Section("Sertifikalar") {
                ForEach(certifications, id: \.self) { cert in
                    Toggle(cert, isOn: Binding(
                        get: { selectedCertifications.contains(cert) },
                        set: { isSelected in
                            if isSelected {
                                selectedCertifications.insert(cert)
                            } else {
                                selectedCertifications.remove(cert)
                            }
                        }
                    ))
                }
            }
            
            // Resimler
            Section("Tarla Resimleri") {
                Button {
                    showingImagePicker = true
                } label: {
                    Label("Resim Ekle", systemImage: "photo.on.rectangle.angled")
                        .foregroundColor(.green)
                }
                
                if !selectedImages.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<selectedImages.count, id: \.self) { index in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: selectedImages[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(8)
                                    
                                    Button {
                                        selectedImages.remove(at: index)
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                    }
                                    .offset(x: 5, y: -5)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Tarla Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        saveFarm()
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImages: $selectedImages, maxSelection: 10)
            }
            .alert("Özel Ürün Ekle", isPresented: $showingAddCrop) {
                TextField("Ürün Adı", text: $customCrop)
                Button("Ekle") {
                    if !customCrop.isEmpty {
                        selectedCrops.insert(customCrop)
                        customCrop = ""
                    }
                }
                Button("İptal", role: .cancel) {
                    customCrop = ""
                }
            }
            .alert("Hata", isPresented: $showingAlert) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Kaydediliyor...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                        .ignoresSafeArea()
                }
            }
        }
    }
    
    private func getCurrentLocation() {
        // CoreLocation ile konum al
        latitude = 39.9334 + Double.random(in: -0.1...0.1)
        longitude = 32.8597 + Double.random(in: -0.1...0.1)
        region.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    private func validateForm() -> Bool {
        if name.isEmpty {
            alertMessage = "Tarla adı boş olamaz"
            return false
        }
        
        if locationName.isEmpty {
            alertMessage = "Konum adı boş olamaz"
            return false
        }
        
        guard let areaValue = Double(area), areaValue > 0 else {
            alertMessage = "Geçerli bir alan girin"
            return false
        }
        
        if latitude == 0.0 || longitude == 0.0 {
            alertMessage = "Lütfen konum belirtin"
            return false
        }
        
        if selectedImages.isEmpty {
            alertMessage = "En az bir resim seçmelisiniz"
            return false
        }
        
        return true
    }
    
    private func saveFarm() {
        guard validateForm() else {
            showingAlert = true
            return
        }
        
        let farm = Farm(
            id: nil,
            farmerId: "current_user_id",
            farmerName: "Çiftçi Adı",
            name: name,
            description: description,
            location: GeoPoint(latitude: latitude, longitude: longitude),
            locationName: locationName,
            address: address,
            area: Double(area) ?? 0,
            areaUnit: selectedAreaUnit,
            soilType: selectedSoilType,
            irrigationType: selectedIrrigationType,
            images: [],
            coordinates: [GeoPoint(latitude: latitude, longitude: longitude)],
            createdAt: Date(),
            updatedAt: Date(),
            isActive: true,
            crops: Array(selectedCrops),
            certifications: Array(selectedCertifications),
            hasWaterAccess: hasWaterAccess,
            hasElectricity: hasElectricity
        )
        
        viewModel.saveFarm(farm, images: selectedImages) { success in
            if success {
                onSave()
                dismiss()
            } else {
                alertMessage = "Tarla kaydedilirken bir hata oluştu"
                showingAlert = true
            }
        }
    }
}

// MARK: - ViewModel
class AddFarmViewModel: ObservableObject {
    @Published var isLoading = false
    
    private let db = Firestore.firestore()
    
    func saveFarm(_ farm: Farm, images: [UIImage], completion: @escaping (Bool) -> Void) {
        isLoading = true
        
        // Resimleri yükle (mock)
        uploadImages(images) { imageUrls in
            // Farm'ı kaydet
            do {
                var farmData = farm
                // farmData.images = imageUrls
                
                try self.db.collection("farms").addDocument(from: farmData) { error in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        completion(error == nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion(false)
                }
            }
        }
    }
    
    private func uploadImages(_ images: [UIImage], completion: @escaping ([String]) -> Void) {
        let mockUrls = images.enumerated().map { index, _ in
            "https://firebasestorage.googleapis.com/farm_image_\(index).jpg"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(mockUrls)
        }
    }
}
