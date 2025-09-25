//
//  UpdateStockView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/25/25.
//
import SwiftUI

struct UpdateStockView: View {
    let product: Product
    let onUpdate: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var quantity: String
    @State private var price: String
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(product: Product, onUpdate: @escaping () -> Void) {
        self.product = product
        self.onUpdate = onUpdate
        _quantity = State(initialValue: String(format: "%.0f", product.quantity))
        _price = State(initialValue: String(format: "%.2f", product.price))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Ürün Bilgileri") {
                    HStack {
                        AsyncImage(url: URL(string: product.images.first ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.title)
                                .font(.headline)
                            Text(product.categoryName)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section("Stok Güncelleme") {
                    HStack {
                        Text("Mevcut Stok:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(String(format: "%.0f", product.quantity)) \(product.unit)")
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        TextField("Yeni Miktar", text: $quantity)
                            .keyboardType(.decimalPad)
                        Text(product.unit)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Fiyat Güncelleme") {
                    HStack {
                        Text("Mevcut Fiyat:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(String(format: "%.2f", product.price)) ₺")
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        TextField("Yeni Fiyat", text: $price)
                            .keyboardType(.decimalPad)
                        Text("₺ / \(product.unit)")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Durum") {
                    Toggle("Satışta", isOn: Binding(
                        get: { product.isActive },
                        set: { _ in }
                    ))
                    .disabled(true)
                    
                    Text("Ürün durumunu değiştirmek için 'Satışa Kapat' butonunu kullanın")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Stok Güncelle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        updateStock()
                    }
                    
                }
            }
            .alert("Bilgi", isPresented: $showingAlert) {
                Button("Tamam", role: .cancel) {
                   
                }
            } message: {
                Text(alertMessage)
            }
           
        }
    }
    
    private func updateStock() {
//        guard let quantityValue = Double(quantity), quantityValue >= 0 else {
//            alertMessage = "Geçerli bir miktar girin"
//            viewModel.hasError = true
//            showingAlert = true
//            return
//        }
//        
//        guard let priceValue = Double(price), priceValue > 0 else {
//            alertMessage = "Geçerli bir fiyat girin"
//            viewModel.hasError = true
//            showingAlert = true
//            return
//        }
//        
//        viewModel.updateStock(
//            productId: product.id ?? "",
//            quantity: quantityValue,
//            price: priceValue
//        ) { success, message in
//            alertMessage = message
//            showingAlert = true
//        }
    }
}
