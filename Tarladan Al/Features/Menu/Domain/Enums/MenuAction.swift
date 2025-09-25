//
//  MenuAction.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/25/25.
//
import SwiftUI

enum MenuAction: String, CaseIterable {
    // Üretici İşlemleri - Stok Yönetimi
    case myProducts = "myProducts"
    case addNewProduct = "addNewProduct"
    case updateStock = "updateStock"
    case closeToSale = "closeToSale"
    
    // Üretici İşlemleri - Hasat Bildirimi
    case harvestDateEntry = "harvestDateEntry"
    case approvalStatus = "approvalStatus"
    
    // Üretici İşlemleri - Tedarik Sözleşmeleri
    case activeContracts = "activeContracts"
    case pendingContracts = "pendingContracts"
    case contractDetails = "contractDetails"
    
    // Üretici İşlemleri - Sigorta Durumu
    case productLossInsurance = "productLossInsurance"
    case naturalDisasterInsurance = "naturalDisasterInsurance"
    case damageReports = "damageReports"
    
    // Güvence - Sigortalar
    case productInsurance = "productInsurance"
    case shippingInsurance = "shippingInsurance"
    case warehouseInsurance = "warehouseInsurance"
    
    // Güvence - Teminatlar
    case manufacturerGuarantee = "manufacturerGuarantee"
    case customerGuarantee = "customerGuarantee"
    case supplierGuaranteeSystem = "supplierGuaranteeSystem"
    
    // Güvence - Yasal Belgeler
    case consumerRights = "consumerRights"
    case manufacturerContracts = "manufacturerContracts"
    case privacyPolicy = "privacyPolicy"
    
    // Kalite - Sertifikalar
    case organicCertificate = "organicCertificate"
    case goodAgriculturalPractices = "goodAgriculturalPractices"
    case isoDocuments = "isoDocuments"
    
    // Kalite - Laboratuvar Test Sonuçları
    case pesticideControl = "pesticideControl"
    case microbiologicalTests = "microbiologicalTests"
    
    // Kalite - Ürün Geçmişi (QR Kod ile)
    case myFarms = "farmInfo"
    case addNewFarm = "addNewFarm"
    case farmDetail = "farmDetail"
    case harvestDate = "harvestDate"
    case storageConditions = "storageConditions"
}
