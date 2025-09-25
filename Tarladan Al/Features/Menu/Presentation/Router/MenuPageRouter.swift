//
//  DetailPageRouter.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/25/25.
//
import SwiftUI

struct MenuPageRouter {
    
    @EnvironmentObject private var menuViewModel: MenuViewModel
    
    static func getDetailView(for action: MenuAction) -> AnyView {
        switch action {
        case .myFarms:
            return AnyView(MyFarmsView())
        case .addNewFarm:
            return AnyView(AddFarmView(){
                
            })
        case .farmDetail:
            return AnyView(MyFarmsView())
        case .myProducts:
            return AnyView(MyProductsView())
        case .addNewProduct:
            return AnyView(AddNewProductView())
        case .updateStock:
            return AnyView(MyProductsView())
        case .closeToSale:
            return AnyView(CloseToSaleView())
        case .harvestDateEntry:
            return AnyView(HarvestDateEntryView())
        case .approvalStatus:
            return AnyView(ApprovalStatusView())
        case .activeContracts:
            return AnyView(ActiveContractsView())
        case .pendingContracts:
            return AnyView(PendingContractsView())
        case .contractDetails:
            return AnyView(ContractDetailsView())
        case .productLossInsurance:
            return AnyView(ProductLossInsuranceView())
        case .naturalDisasterInsurance:
            return AnyView(NaturalDisasterInsuranceView())
        case .damageReports:
            return AnyView(DamageReportsView())
        case .productInsurance:
            return AnyView(ProductInsuranceView())
        case .shippingInsurance:
            return AnyView(ShippingInsuranceView())
        case .warehouseInsurance:
            return AnyView(WarehouseInsuranceView())
        case .manufacturerGuarantee:
            return AnyView(ManufacturerGuaranteeView())
        case .customerGuarantee:
            return AnyView(CustomerGuaranteeView())
        case .supplierGuaranteeSystem:
            return AnyView(SupplierGuaranteeSystemView())
        case .consumerRights:
            return AnyView(ConsumerRightsView())
        case .manufacturerContracts:
            return AnyView(ManufacturerContractsView())
        case .privacyPolicy:
            return AnyView(PrivacyPolicyView())
        case .organicCertificate:
            return AnyView(OrganicCertificateView())
        case .goodAgriculturalPractices:
            return AnyView(GoodAgriculturalPracticesView())
        case .isoDocuments:
            return AnyView(ISODocumentsView())
        case .pesticideControl:
            return AnyView(PesticideControlView())
        case .microbiologicalTests:
            return AnyView(MicrobiologicalTestsView())
        case .harvestDate:
            return AnyView(HarvestDateView())
        case .storageConditions:
            return AnyView(StorageConditionsView())
        }
    }
}
