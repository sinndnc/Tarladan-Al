//
//  CartItem.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/17/25.
//

import SwiftUI

// MARK: - CheckOutView
struct CheckOutView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    
    @State private var selectedPaymentMethod: PaymentMethod.PaymentType = .card
    @State private var showingOrderConfirmation = false
    @State private var isProcessingOrder = false
    
    @State private var selectedAddress: Address?
    @State private var showingAddressForm = false
    @State private var isExpanded = false
    
    private var shippingCost: Double {
        cartViewModel.totalPrice > 50000 ? 0 : 49.99
    }
    
    private var tax: Double {
        cartViewModel.totalPrice * 0.18 // KDV %18
    }
    
    private var total: Double {
        cartViewModel.totalPrice + shippingCost + tax
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    // Sepet Özeti
                    cartSummarySection
                    
                    // Teslimat Adresi
                    
                    // Adres Listesi
                    addressListSection
                    
                    // Ödeme Yöntemi
                    paymentMethodSection
                    
                    // Fiyat Özeti
                    priceSummarySection
                    
                    // Sipariş Ver Butonu
                    checkoutButton
                }
                .padding()
            }
            .navigationTitle("Ödeme")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Sipariş Onaylandı!", isPresented: $showingOrderConfirmation) {
                Button("Tamam") { }
            } message: {
                Text("Siparişiniz başarıyla alındı. Kargo takip bilgileri e-posta adresinize gönderilecektir.")
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        dismiss()
                    }label: {
                        HStack{
                            Image(systemName: "arrow.left")
                            Text("To Cart")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Sepet Özeti
    private var cartSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "cart.fill")
                    .foregroundColor(.blue)
                Text("Sepetiniz")
                    .font(.headline)
                Spacer()
                Text("\(cartViewModel.items.count) ürün")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            ForEach(cartViewModel.items) { item in
                HStack {
                    // Ürün görseli placeholder
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.product.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        HStack {
                            Text("Adet: \(item.quantity)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("₺\(item.totalPrice, specifier: "%.2f")")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 4)
                
                if item.id != cartViewModel.items.last?.id {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    
    // MARK: - Seçili Adres Kartı
    private func selectedAddressCard(_ address: Address) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.green)
                Text("Seçili Teslimat Adresi")
                    .font(.headline)
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(address.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        
                        if address.isDefault {
                            Text("Varsayılan")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.green)
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                    }
                    
                    Text(address.fullAddress)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Text("\(address.district), \(address.city)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title2)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.green.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.green.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Adres Listesi
    private var addressListSection: some View {
        VStack(spacing: 8) {
            if let user = userViewModel.user,
               let selectedAddress = user.defaultAddress{
                selectedAddressCard(selectedAddress)
                
                ForEach(user.addresses.filter { !$0.isDefault }) { address in
                    addressCard(address)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .transition(.opacity.combined(with: .move(edge: .top)))
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    // MARK: - Adres Kartı
    private func addressCard(_ address: Address) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
//                MARK: - Change the default address
            }
        }) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(address.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            if address.isDefault {
                                Text("Varsayılan")
                                    .font(.caption)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundColor(.blue)
                                    .cornerRadius(6)
                            }
                            
                            Spacer()
                        }
                        
                        Text(address.fullAddress)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        
                        Text("\(address.district), \(address.city)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "circle")
                        .foregroundColor(.gray)
                        .font(.title3)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Yeni Adres Ekle Butonu
    private var addNewAddressButton: some View {
        Button(action: {
            showingAddressForm = true
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title3)
                
                Text("Yeni Adres Ekle")
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
                    .font(.caption)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    .background(Color.blue.opacity(0.05))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    private var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "creditcard.fill")
                    .foregroundColor(.orange)
                Text("Ödeme Yöntemi")
                    .font(.headline)
                Spacer()
            }
            
            VStack(spacing: 8) {
                ForEach(PaymentMethod.PaymentType.allCases, id: \.self) { method in
                    Button(action: {
                        selectedPaymentMethod = method
                    }) {
                        HStack {
                            Image(systemName: selectedPaymentMethod == method ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedPaymentMethod == method ? .blue : .gray)
                            
                            Text(method.rawValue)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            // Ödeme yöntemi ikonu
                            Image(systemName: paymentMethodIcon(for: method))
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(selectedPaymentMethod == method ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    // MARK: - Fiyat Özeti
    private var priceSummarySection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Ara Toplam")
                Spacer()
                Text("₺\(cartViewModel.totalPrice, specifier: "%.2f")")
            }
            
            HStack {
                Text("Kargo")
                Spacer()
                if shippingCost == 0 {
                    Text("Ücretsiz")
                        .foregroundColor(.green)
                } else {
                    Text("₺\(shippingCost, specifier: "%.2f")")
                }
            }
            
            HStack {
                Text("KDV (%18)")
                Spacer()
                Text("₺\(tax, specifier: "%.2f")")
            }
            
            Divider()
            
            HStack {
                Text("Toplam")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("₺\(total, specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    // MARK: - Sipariş Ver Butonu
    private var checkoutButton: some View {
        Button{
            
        }label: {
            HStack {
                if isProcessingOrder {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "checkmark.circle.fill")
                }
                
                Text(isProcessingOrder ? "İşleniyor..." : "Siparişi Tamamla")
                    .fontWeight(.semibold)
            }
            .padding()
            .background(.blue)
            .cornerRadius(10)
            .foregroundColor(.white)
        }
    }
    
    // MARK: - Helper Functions
    private func paymentMethodIcon(for method: PaymentMethod.PaymentType) -> String {
        switch method {
        case .card:
            return "creditcard"
        case .paypal:
            return "apple.logo"
        case .bankTransfer:
            return "banknote"
        }
    }
    
}

// MARK: - Preview
struct CheckOutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckOutView()
    }
}
