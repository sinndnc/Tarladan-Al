//
//  MenuViewModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/22/25.
//

import Foundation

final class MenuViewModel : ObservableObject{
    
    @Published var menuItems: [MenuSection] = []
    @Published var selectedItem: Product? = nil
    
    init() {
        setupMenuItems()
    }
    
}

extension MenuViewModel{
    
    private func setupMenuItems() {
        menuItems =  [
            MenuSection(
                title: "Tarla Yönetimi",
                items: [
                    MenuItem(title: "Tarlalarım", icon: "field.of.view.wide", action: .myFarms),
                    MenuItem(title: "Yeni Tarla Ekle", icon: "plus.circle", action: .addNewFarm),
                    MenuItem(title: "Tarla Güncelle", icon: "arrow.triangle.2.circlepath", action: .addNewFarm),
                    MenuItem(title: "Tarla Kapat", icon: "xmark.circle", action: .closeToSale)
                ]
            ),
            MenuSection(
                title: "Stok Yönetimi",
                items: [
                    MenuItem(title: "Ürünlerim", icon: "leaf", action: .myProducts),
                    MenuItem(title: "Yeni Ürün Ekle", icon: "plus.circle", action: .addNewProduct),
                    MenuItem(title: "Stok Güncelle", icon: "arrow.triangle.2.circlepath", action: .updateStock),
                    MenuItem(title: "Satışa Kapat", icon: "xmark.circle", action: .closeToSale)
                ]
            ),
            MenuSection(
                title: "Hasat Bildirimi",
                items: [
                    MenuItem(title: "Tarih ve Miktar Girişi", icon: "calendar.badge.plus", action: .harvestDateEntry),
                    MenuItem(title: "Onay Durumu", icon: "checkmark.seal", action: .approvalStatus)
                ]
            ),
            MenuSection(
                title: "Tedarik Sözleşmeleri",
                items: [
                    MenuItem(title: "Aktif Sözleşmeler", icon: "doc.text", action: .activeContracts),
                    MenuItem(title: "Bekleyen Sözleşmeler", icon: "clock.badge", action: .pendingContracts),
                    MenuItem(title: "Sözleşme Detayları", icon: "doc.plaintext", action: .contractDetails)
                ]
            ),
            MenuSection(
                title: "Sigorta Durumu",
                items: [
                    MenuItem(title: "Ürün Kaybı Sigortası", icon: "shield.lefthalf.filled", action: .productLossInsurance),
                    MenuItem(title: "Doğal Afet Sigortası", icon: "cloud.bolt", action: .naturalDisasterInsurance),
                    MenuItem(title: "Hasar Bildirimleri", icon: "exclamationmark.triangle", action: .damageReports)
                ]
            ),
            MenuSection(
                title: "Sigortalar",
                items: [
                    MenuItem(title: "Ürün Sigortaları", icon: "shield", action: .productInsurance),
                    MenuItem(title: "Nakliye Sigortaları", icon: "truck.box", action: .shippingInsurance),
                    MenuItem(title: "Depo Sigortaları", icon: "building.2", action: .warehouseInsurance)
                ]
            ),
            MenuSection(
                title: "Teminatlar",
                items: [
                    MenuItem(title: "Üretici Teminatı", icon: "person.badge.shield.checkmark", action: .manufacturerGuarantee),
                    MenuItem(title: "Müşteri Teminatı", icon: "person.2.badge.gearshape", action: .customerGuarantee),
                    MenuItem(title: "Tedarikçi Güvence Sistemi", icon: "network.badge.shield.half.filled", action: .supplierGuaranteeSystem)
                ]
            ),
            MenuSection(
                title: "Yasal Belgeler",
                items: [
                    MenuItem(title: "Tüketici Hakları", icon: "person.text.rectangle", action: .consumerRights),
                    MenuItem(title: "Üretici Sözleşmeleri", icon: "doc.badge.gearshape", action: .manufacturerContracts),
                    MenuItem(title: "KVKK / Gizlilik Politikası", icon: "lock.doc", action: .privacyPolicy)
                ]
            ),
            MenuSection(
                title: "Sertifikalar",
                items: [
                    MenuItem(title: "Organik Sertifika", icon: "leaf", action: .organicCertificate),
                    MenuItem(title: "İyi Tarım Uygulamaları Sertifikası", icon: "hand.thumbsup", action: .goodAgriculturalPractices),
                    MenuItem(title: "ISO Belgeleri", icon: "doc.badge.gearshape", action: .isoDocuments)
                ]
            ),
            MenuSection(
                title: "Laboratuvar Test Sonuçları",
                items: [
                    MenuItem(title: "Pestisit Kontrolü", icon: "drop.triangle", action: .pesticideControl),
                    MenuItem(title: "Mikrobiyolojik Testler", icon: "microbe.circle.fill", action: .microbiologicalTests)
                ]
            ),
            MenuSection(
                title: "Ürün Geçmişi (QR Kod ile)",
                items: [
                    MenuItem(title: "Çiftlik Bilgisi", icon: "house", action: .myFarms),
                    MenuItem(title: "Hasat Tarihi", icon: "calendar", action: .harvestDate),
                    MenuItem(title: "Depolama Koşulları", icon: "thermometer.medium", action: .storageConditions)
                ]
            )
        ]
    }
}

