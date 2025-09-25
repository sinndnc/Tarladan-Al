//
//  AddNewProductView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/25/25.
//
import SwiftUI
import FirebaseFirestore
import PhotosUI

struct AddNewProductView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddProductViewModel()
    
    // Form Fields
    @State private var title = ""
    @State private var description = ""
    @State private var price = ""
    @State private var unit = "kg"
    @State private var quantity = ""
    @State private var selectedCategory = ""
    @State private var selectedSubCategory = ""
    @State private var locationName = ""
    @State private var isOrganic = false
    @State private var harvestDate = Date()
    @State private var expiryDate = Date()
    @State private var hasHarvestDate = false
    @State private var hasExpiryDate = false
    
    // Image Selection
    @State private var selectedImages: [UIImage] = []
    @State private var showingImagePicker = false
    
    // Location
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    
    // Validation
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let units = ["kg", "gram", "adet", "litre", "paket", "kasa"]
    let categories = ["Meyve", "Sebze", "Tahıl", "Bakliyat", "Süt Ürünleri", "Et Ürünleri"]
    let subCategories = ["Organik", "Doğal", "İşlenmiş", "Taze", "Donuk", "Kurutulmuş"]
    
    var body: some View {
        Form {
            // Temel Bilgiler
            Section("Ürün Bilgileri") {
                TextField("Ürün Adı", text: $title)
                
                TextField("Ürün Açıklaması", text: $description, axis: .vertical)
                    .lineLimit(3...6)
            }
            
            // Kategori Seçimi
            Section("Kategori") {
                Picker("Kategori", selection: $selectedCategory) {
                    Text("Kategori Seçin").tag("")
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Picker("Alt Kategori", selection: $selectedSubCategory) {
                    Text("Alt Kategori Seçin").tag("")
                    ForEach(subCategories, id: \.self) { subCategory in
                        Text(subCategory).tag(subCategory)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            // Fiyat ve Miktar
            Section("Fiyat ve Miktar") {
                HStack {
                    TextField("Fiyat", text: $price)
                        .keyboardType(.decimalPad)
                    Text("₺")
                }
                
                HStack {
                    TextField("Miktar", text: $quantity)
                        .keyboardType(.decimalPad)
                    
                    Picker("Birim", selection: $unit) {
                        ForEach(units, id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            
            // Özellikler
            Section("Özellikler") {
                Toggle("Organik Ürün", isOn: $isOrganic)
                
                Toggle("Hasat Tarihi Belirt", isOn: $hasHarvestDate)
                if hasHarvestDate {
                    DatePicker("Hasat Tarihi", selection: $harvestDate, displayedComponents: .date)
                }
                
                Toggle("Son Kullanma Tarihi Belirt", isOn: $hasExpiryDate)
                if hasExpiryDate {
                    DatePicker("Son Kullanma Tarihi", selection: $expiryDate, displayedComponents: .date)
                }
            }
            
            // Konum
            Section("Konum") {
                TextField("Konum Adı (örn: Ankara, Çankaya)", text: $locationName)
                
                HStack {
                    Button("Mevcut Konumu Kullan") {
                        getCurrentLocation()
                    }
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    if latitude != 0.0 && longitude != 0.0 {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
            }
            
            // Resim Seçimi
            Section("Ürün Resimleri") {
                Button("Resim Ekle") {
                    showingImagePicker = true
                }
                .foregroundColor(.blue)
                
                if !selectedImages.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<selectedImages.count, id: \.self) { index in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: selectedImages[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipped()
                                        .cornerRadius(8)
                                    
                                    Button(action: {
                                        selectedImages.remove(at: index)
                                    }) {
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
        }
        .navigationTitle("Ürün Ekle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Kaydet") {
                    saveProduct()
                }
                .disabled(viewModel.isLoading)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImages: $selectedImages, maxSelection: 5)
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
    
    private func getCurrentLocation() {
        // LocationManager kullanarak mevcut konumu al
        // Bu kısımda CoreLocation kullanmanız gerekecek
        latitude = 39.9334 // Örnek koordinatlar (Ankara)
        longitude = 32.8597
    }
    
    private func validateForm() -> Bool {
        if title.isEmpty {
            alertMessage = "Ürün adı boş olamaz"
            return false
        }
        
        if description.isEmpty {
            alertMessage = "Ürün açıklaması boş olamaz"
            return false
        }
        
        if selectedCategory.isEmpty {
            alertMessage = "Lütfen bir kategori seçin"
            return false
        }
        
        if selectedSubCategory.isEmpty {
            alertMessage = "Lütfen bir alt kategori seçin"
            return false
        }
        
        guard let priceValue = Double(price), priceValue > 0 else {
            alertMessage = "Geçerli bir fiyat girin"
            return false
        }
        
        guard let quantityValue = Double(quantity), quantityValue > 0 else {
            alertMessage = "Geçerli bir miktar girin"
            return false
        }
        
        if locationName.isEmpty {
            alertMessage = "Konum adı boş olamaz"
            return false
        }
        
        if selectedImages.isEmpty {
            alertMessage = "En az bir resim seçmelisiniz"
            return false
        }
        
        return true
    }
    
    private func saveProduct() {
        guard validateForm() else {
            showingAlert = true
            return
        }
        
        let product = Product(
            id: nil,
            farmerId: "current_user_id", // Gerçek kullanıcı ID'si buraya gelecek
            farmerName: "Çiftçi Adı", // Gerçek çiftçi adı buraya gelecek
            farmerPhone: "0555 123 4567", // Gerçek telefon numarası buraya gelecek
            categoryName: selectedCategory,
            subCategoryName: selectedSubCategory,
            title: title,
            description: description,
            price: Double(price) ?? 0.0,
            unit: unit,
            quantity: Double(quantity) ?? 0.0,
            images: [], // Resimler yüklendikten sonra URL'ler buraya gelecek
            location: GeoPoint(latitude: latitude, longitude: longitude),
            locationName: locationName,
            createdAt: Date(),
            updatedAt: Date(),
            isActive: true,
            isOrganic: isOrganic,
            harvestDate: hasHarvestDate ? harvestDate : nil,
            expiryDate: hasExpiryDate ? expiryDate : nil
        )
        
        viewModel.saveProduct(product, images: selectedImages) { success in
            if success {
                dismiss()
            } else {
                alertMessage = "Ürün kaydedilirken bir hata oluştu"
                showingAlert = true
            }
        }
    }
}

// MARK: - ViewModel
class AddProductViewModel: ObservableObject {
    @Published var isLoading = false
    
    func saveProduct(_ product: Product, images: [UIImage], completion: @escaping (Bool) -> Void) {
        isLoading = true
        
        // Önce resimleri yükle
        uploadImages(images) { [weak self] imageUrls in
            guard let self = self else { return }
            
            // Resim URL'lerini ürüne ekle
            var updatedProduct = product
            // updatedProduct.images = imageUrls // Product struct'ını mutable yapmak gerekebilir
            
            // Ürünü Firestore'a kaydet
            self.saveToFirestore(updatedProduct) { success in
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion(success)
                }
            }
        }
    }
    
    private func uploadImages(_ images: [UIImage], completion: @escaping ([String]) -> Void) {
        // Firebase Storage'a resim yükleme işlemi
        // Bu kısımda Firebase Storage kullanmanız gerekecek
        
        // Şimdilik mock URL'ler döndürüyoruz
        let mockUrls = images.enumerated().map { index, _ in
            "https://firebasestorage.googleapis.com/image_\(index).jpg"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(mockUrls)
        }
    }
    
    private func saveToFirestore(_ product: Product, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        do {
            try db.collection("products").addDocument(from: product) { error in
                completion(error == nil)
            }
        } catch {
            completion(false)
        }
    }
}

// MARK: - ImagePicker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    let maxSelection: Int
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = maxSelection
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.dismiss()
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let uiImage = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.selectedImages.append(uiImage)
                            }
                        }
                    }
                }
            }
        }
    }
}
