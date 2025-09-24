//
//  MenuViewModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/22/25.
//

import Foundation

final class MenuViewModel : ObservableObject{
    
    @Published var menuItems: [MenuItem] = []
    
    init() {
        setupMenuItems()
    }
    
}

extension MenuViewModel{
    
    private func setupMenuItems() {
        menuItems = [
            // Üretici İşlemleri
            MenuItem(
                title: "Üretici İşlemleri (Çiftçi Paneli)",
                icon: "person.crop.circle.badge.plus",
                subItems: [
                    // Stok Yönetimi Alt Kategorileri
                    SubMenuItem(title: "Yeni Ürün Ekle", icon: "plus.circle", action: .addNewProduct),
                    SubMenuItem(title: "Stok Güncelle", icon: "arrow.triangle.2.circlepath", action: .updateStock),
                    SubMenuItem(title: "Satışa Kapat", icon: "xmark.circle", action: .closeToSale),
                    
                    // Hasat Bildirimi Alt Kategorileri
                    SubMenuItem(title: "Tarih ve Miktar Girişi", icon: "calendar.badge.plus", action: .harvestDateEntry),
                    SubMenuItem(title: "Onay Durumu", icon: "checkmark.seal", action: .approvalStatus),
                    
                    // Tedarik Sözleşmeleri Alt Kategorileri
                    SubMenuItem(title: "Aktif Sözleşmeler", icon: "doc.text", action: .activeContracts),
                    SubMenuItem(title: "Bekleyen Sözleşmeler", icon: "clock.badge", action: .pendingContracts),
                    SubMenuItem(title: "Sözleşme Detayları", icon: "doc.plaintext", action: .contractDetails),
                    
                    // Sigorta Durumu Alt Kategorileri
                    SubMenuItem(title: "Ürün Kaybı Sigortası", icon: "shield.lefthalf.filled", action: .productLossInsurance),
                    SubMenuItem(title: "Doğal Afet Sigortası", icon: "cloud.bolt", action: .naturalDisasterInsurance),
                    SubMenuItem(title: "Hasar Bildirimleri", icon: "exclamationmark.triangle", action: .damageReports)
                ],
                category: .producer
            ),
            
            // Güvence ve Yasal İşlemler
            MenuItem(
                title: "Güvence ve Yasal İşlemler",
                icon: "shield.checkered",
                subItems: [
                    // Sigortalar Alt Kategorileri
                    SubMenuItem(title: "Ürün Sigortaları", icon: "shield", action: .productInsurance),
                    SubMenuItem(title: "Nakliye Sigortaları", icon: "truck.box", action: .shippingInsurance),
                    SubMenuItem(title: "Depo Sigortaları", icon: "building.2", action: .warehouseInsurance),
                    
                    // Teminatlar Alt Kategorileri
                    SubMenuItem(title: "Üretici Teminatı", icon: "person.badge.shield.checkmark", action: .manufacturerGuarantee),
                    SubMenuItem(title: "Müşteri Teminatı", icon: "person.2.badge.gearshape", action: .customerGuarantee),
                    SubMenuItem(title: "Tedarikçi Güvence Sistemi", icon: "network.badge.shield.half.filled", action: .supplierGuaranteeSystem),
                    
                    // Yasal Belgeler Alt Kategorileri
                    SubMenuItem(title: "Tüketici Hakları", icon: "person.text.rectangle", action: .consumerRights),
                    SubMenuItem(title: "Üretici Sözleşmeleri", icon: "doc.badge.gearshape", action: .manufacturerContracts),
                    SubMenuItem(title: "KVKK / Gizlilik Politikası", icon: "lock.doc", action: .privacyPolicy)
                ],
                category: .guarantee
            ),
            
            // Kalite ve Sertifikasyon
            MenuItem(
                title: "Kalite ve Sertifikasyon",
                icon: "rosette",
                subItems: [
                    // Sertifikalar Alt Kategorileri
                    SubMenuItem(title: "Organik Sertifika", icon: "leaf", action: .organicCertificate),
                    SubMenuItem(title: "İyi Tarım Uygulamaları Sertifikası", icon: "hand.thumbsup", action: .goodAgriculturalPractices),
                    SubMenuItem(title: "ISO Belgeleri", icon: "doc.badge.gearshape", action: .isoDocuments),
                    
                    // Laboratuvar Test Sonuçları Alt Kategorileri
                    SubMenuItem(title: "Pestisit Kontrolü", icon: "drop.triangle", action: .pesticideControl),
                    SubMenuItem(title: "Mikrobiyolojik Testler", icon: "microbe.circle.fill", action: .microbiologicalTests),
                    
                    // Ürün Geçmişi (QR Kod ile) Alt Kategorileri
                    SubMenuItem(title: "Çiftlik Bilgisi", icon: "house", action: .farmInfo),
                    SubMenuItem(title: "Hasat Tarihi", icon: "calendar", action: .harvestDate),
                    SubMenuItem(title: "Depolama Koşulları", icon: "thermometer.medium", action: .storageConditions)
                ],
                category: .quality
            )
        ]
    }
    
    // Her ana kategori için section'ları döndürür
    func getSectionsForCategory(_ category: MenuCategory) -> [MenuSection] {
        switch category {
        case .producer:
            return [
                MenuSection(
                    title: "Stok Yönetimi",
                    icon: "cube.box",
                    items: [
                        SubMenuItem(title: "Yeni Ürün Ekle", icon: "plus.circle", action: .addNewProduct),
                        SubMenuItem(title: "Stok Güncelle", icon: "arrow.triangle.2.circlepath", action: .updateStock),
                        SubMenuItem(title: "Satışa Kapat", icon: "xmark.circle", action: .closeToSale)
                    ]
                ),
                MenuSection(
                    title: "Hasat Bildirimi",
                    icon: "leaf.arrow.circlepath",
                    items: [
                        SubMenuItem(title: "Tarih ve Miktar Girişi", icon: "calendar.badge.plus", action: .harvestDateEntry),
                        SubMenuItem(title: "Onay Durumu", icon: "checkmark.seal", action: .approvalStatus)
                    ]
                ),
                MenuSection(
                    title: "Tedarik Sözleşmeleri",
                    icon: "doc.text",
                    items: [
                        SubMenuItem(title: "Aktif Sözleşmeler", icon: "doc.text", action: .activeContracts),
                        SubMenuItem(title: "Bekleyen Sözleşmeler", icon: "clock.badge", action: .pendingContracts),
                        SubMenuItem(title: "Sözleşme Detayları", icon: "doc.plaintext", action: .contractDetails)
                    ]
                ),
                MenuSection(
                    title: "Sigorta Durumu",
                    icon: "shield.lefthalf.filled",
                    items: [
                        SubMenuItem(title: "Ürün Kaybı Sigortası", icon: "shield.lefthalf.filled", action: .productLossInsurance),
                        SubMenuItem(title: "Doğal Afet Sigortası", icon: "cloud.bolt", action: .naturalDisasterInsurance),
                        SubMenuItem(title: "Hasar Bildirimleri", icon: "exclamationmark.triangle", action: .damageReports)
                    ]
                )
            ]
            
        case .guarantee:
            return [
                MenuSection(
                    title: "Sigortalar",
                    icon: "shield",
                    items: [
                        SubMenuItem(title: "Ürün Sigortaları", icon: "shield", action: .productInsurance),
                        SubMenuItem(title: "Nakliye Sigortaları", icon: "truck.box", action: .shippingInsurance),
                        SubMenuItem(title: "Depo Sigortaları", icon: "building.2", action: .warehouseInsurance)
                    ]
                ),
                MenuSection(
                    title: "Teminatlar",
                    icon: "checkmark.shield",
                    items: [
                        SubMenuItem(title: "Üretici Teminatı", icon: "person.badge.shield.checkmark", action: .manufacturerGuarantee),
                        SubMenuItem(title: "Müşteri Teminatı", icon: "person.2.badge.gearshape", action: .customerGuarantee),
                        SubMenuItem(title: "Tedarikçi Güvence Sistemi", icon: "network.badge.shield.half.filled", action: .supplierGuaranteeSystem)
                    ]
                ),
                MenuSection(
                    title: "Yasal Belgeler",
                    icon: "doc.badge.gearshape",
                    items: [
                        SubMenuItem(title: "Tüketici Hakları", icon: "person.text.rectangle", action: .consumerRights),
                        SubMenuItem(title: "Üretici Sözleşmeleri", icon: "doc.badge.gearshape", action: .manufacturerContracts),
                        SubMenuItem(title: "KVKK / Gizlilik Politikası", icon: "lock.doc", action: .privacyPolicy)
                    ]
                )
            ]
            
        case .quality:
            return [
                MenuSection(
                    title: "Sertifikalar",
                    icon: "rosette",
                    items: [
                        SubMenuItem(title: "Organik Sertifika", icon: "leaf", action: .organicCertificate),
                        SubMenuItem(title: "İyi Tarım Uygulamaları Sertifikası", icon: "hand.thumbsup", action: .goodAgriculturalPractices),
                        SubMenuItem(title: "ISO Belgeleri", icon: "doc.badge.gearshape", action: .isoDocuments)
                    ]
                ),
                MenuSection(
                    title: "Laboratuvar Test Sonuçları",
                    icon: "microbe.circle.fill",
                    items: [
                        SubMenuItem(title: "Pestisit Kontrolü", icon: "drop.triangle", action: .pesticideControl),
                        SubMenuItem(title: "Mikrobiyolojik Testler", icon: "microbe.circle.fill", action: .microbiologicalTests)
                    ]
                ),
                MenuSection(
                    title: "Ürün Geçmişi (QR Kod ile)",
                    icon: "qrcode",
                    items: [
                        SubMenuItem(title: "Çiftlik Bilgisi", icon: "house", action: .farmInfo),
                        SubMenuItem(title: "Hasat Tarihi", icon: "calendar", action: .harvestDate),
                        SubMenuItem(title: "Depolama Koşulları", icon: "thermometer.medium", action: .storageConditions)
                    ]
                )
            ]
        }
    }
}
