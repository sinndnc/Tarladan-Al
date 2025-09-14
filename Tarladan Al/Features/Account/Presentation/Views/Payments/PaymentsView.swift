//
//  PaymentMethodsView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//

import SwiftUI

struct PaymentsView: View {
    
    @State private var showingAddPaymentMethod = false
    @EnvironmentObject private var userViewModel: UserViewModel
    
    var body: some View {
        List {
            if let user = userViewModel.user{
                if user.paymentMethods.isEmpty {
                    Text("No Payment Method Found")
                }else{
                    ForEach(user.paymentMethods) { method in
                        NavigationLink(destination: PaymentDetailView(paymentMethod: method)) {
                            PaymentsRowView(paymentMethod: method)
                        }
                    }
                    .onDelete(perform: deletePaymentMethods)
                }
            }
        }
        .navigationTitle("Ödeme Yöntemleri")
        .toolbarTitleDisplayMode(.inline)
        .background(Colors.System.background)
        .toolbarColorScheme(.dark, for:.navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Colors.UI.tabBackground, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddPaymentMethod = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddPaymentMethod) {
            AddPaymentView()
        }
    }
    
    func deletePaymentMethods(offsets: IndexSet) {
        if var user = userViewModel.user{
            user.paymentMethods.remove(atOffsets: offsets)
        }
    }
}

// MARK: - Payment Method Row View
struct PaymentsRowView: View {
    let paymentMethod: PaymentMethod
    
    var body: some View {
        HStack(spacing: 16) {
            // Payment Method Icon
            Image(systemName: paymentMethodIcon)
                .font(.title2)
                .foregroundColor(paymentMethodColor)
                .frame(width: 40, height: 40)
                .background(paymentMethodColor.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(paymentMethodTitle)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if paymentMethod.isDefault {
                        Text("Varsayılan")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(4)
                    }
                    
                    Spacer()
                }
                
                Text(paymentMethodSubtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if paymentMethod.type == .card {
                    Text("Son kullanma: \(paymentMethod.expiryMonth)/\(paymentMethod.expiryYear)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private var paymentMethodIcon: String {
        switch paymentMethod.type {
        case .card:
            return "creditcard.fill"
        case .paypal:
            return "dollarsign.circle.fill"
        case .bankTransfer:
            return "building.columns.fill"
        }
    }
    
    private var paymentMethodColor: Color {
        switch paymentMethod.type {
        case .card:
            return .blue
        case .paypal:
            return .orange
        case .bankTransfer:
            return .green
        }
    }
    
    private var paymentMethodTitle: String {
        switch paymentMethod.type {
        case .card:
            return "•••• •••• •••• \(paymentMethod.lastFour)"
        case .paypal:
            return "PayPal"
        case .bankTransfer:
            return "Banka Transferi"
        }
    }
    
    private var paymentMethodSubtitle: String {
        switch paymentMethod.type {
        case .card:
            return paymentMethod.cardHolderName
        case .paypal:
            return paymentMethod.cardHolderName // Email address
        case .bankTransfer:
            return "Banka hesabı"
        }
    }
}

// MARK: - Payment Method Detail View
struct PaymentDetailView: View {
    let paymentMethod: PaymentMethod
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header Card
                PaymentCardView(paymentMethod: paymentMethod)
                    .padding(.horizontal)
                
                Divider()
                
                // Payment Method Information
                VStack(spacing: 16) {
                    PaymentInfoRow(
                        title: "Ödeme Türü",
                        value: paymentMethod.type.displayName,
                        icon: paymentMethodIcon
                    )
                    
                    if paymentMethod.type == .card {
                        PaymentInfoRow(
                            title: "Kart Sahibi",
                            value: paymentMethod.cardHolderName,
                            icon: "person.fill"
                        )
                        
                        PaymentInfoRow(
                            title: "Son Dört Hanesi",
                            value: paymentMethod.lastFour,
                            icon: "number"
                        )
                        
                        PaymentInfoRow(
                            title: "Son Kullanma Tarihi",
                            value: "\(paymentMethod.expiryMonth)/\(paymentMethod.expiryYear)",
                            icon: "calendar"
                        )
                    } else if paymentMethod.type == .paypal {
                        PaymentInfoRow(
                            title: "PayPal Hesabı",
                            value: paymentMethod.cardHolderName,
                            icon: "at"
                        )
                    }
                    
                    PaymentInfoRow(
                        title: "Durum",
                        value: paymentMethod.isDefault ? "Varsayılan Ödeme Yöntemi" : "Alternatif Ödeme Yöntemi",
                        icon: paymentMethod.isDefault ? "checkmark.circle.fill" : "circle"
                    )
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
                            Text("Ödeme Yöntemini Düzenle")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    if !paymentMethod.isDefault {
                        Button(action: {
                            // Varsayılan yap fonksiyonu
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle")
                                Text("Varsayılan Yap")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Ödeme Yöntemini Sil")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Ödeme Detayı")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditPaymentView(paymentMethod: paymentMethod)
        }
        .alert("Ödeme Yöntemini Sil", isPresented: $showingDeleteAlert) {
            Button("İptal", role: .cancel) { }
            Button("Sil", role: .destructive) {
                // Delete payment method
            }
        } message: {
            Text("Bu ödeme yöntemini silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.")
        }
    }
    
    private var paymentMethodIcon: String {
        switch paymentMethod.type {
        case .card:
            return "creditcard.fill"
        case .paypal:
            return "dollarsign.circle.fill"
        case .bankTransfer:
            return "building.columns.fill"
        }
    }
}

// MARK: - Payment Method Card View
struct PaymentCardView: View {
    let paymentMethod: PaymentMethod
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: cardIcon)
                    .font(.title)
                    .foregroundColor(.white)
                
                Spacer()
                
                if paymentMethod.isDefault {
                    Text("VARSAYILAN")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(4)
                }
            }
            
            Spacer()
            
            if paymentMethod.type == .card {
                Text("•••• •••• •••• \(paymentMethod.lastFour)")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .tracking(2)
                
                HStack {
                    Text(paymentMethod.cardHolderName.uppercased())
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Spacer()
                    
                    Text("\(paymentMethod.expiryMonth)/\(String(paymentMethod.expiryYear).suffix(2))")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
            } else {
                Text(paymentMethod.type.displayName)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(paymentMethod.cardHolderName)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .padding(20)
        .frame(height: 200)
        .background(
            LinearGradient(
                gradient: cardGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }
    
    private var cardIcon: String {
        switch paymentMethod.type {
        case .card:
            return "creditcard.fill"
        case .paypal:
            return "dollarsign.circle.fill"
        case .bankTransfer:
            return "building.columns.fill"
        }
    }
    
    private var cardGradient: Gradient {
        switch paymentMethod.type {
        case .card:
            return Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)])
        case .paypal:
            return Gradient(colors: [Color.orange.opacity(0.8), Color.red.opacity(0.8)])
        case .bankTransfer:
            return Gradient(colors: [Color.green.opacity(0.8), Color.teal.opacity(0.8)])
        }
    }
}

// MARK: - Payment Info Row Component
struct PaymentInfoRow: View {
    let title: String
    let value: String
    let icon: String
    
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

// MARK: - Add Payment Method View
struct AddPaymentView: View {
    @Environment(\.dismiss) private var  dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Yeni Ödeme Yöntemi Ekleme")
                    .font(.title2)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Yeni Ödeme Yöntemi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        // Save new payment method
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Edit Payment Method View
struct EditPaymentView: View {
    
    let paymentMethod: PaymentMethod
    @Environment(\.dismiss) private var  dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Ödeme Yöntemi Düzenleme")
                    .font(.title2)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        // Save changes
                        dismiss()
                    }
                }
            }
        }
    }
}

