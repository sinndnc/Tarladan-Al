//
//  MenuView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/22/25.
//
import SwiftUI

struct MenuView: View {
    
    @EnvironmentObject private var  menuViewModel : MenuViewModel
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(menuViewModel.menuItems){ menuItem in
                    ForEach(menuViewModel.getSectionsForCategory(menuItem.category), id: \.self) { section in
                        Section {
                            ForEach(section.items, id: \.self) { subItem in
                                SubMenuRowView(subMenuItem: subItem)
                            }
                        } header: {
                            HStack {
                                Image(systemName: section.icon)
                                    .foregroundColor(.green)
                                Text(section.title)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
            }
            .navigationTitle("İşlemler")
            .navigationBarTitleDisplayMode(.inline)
            .navigationSubtitleCompat("Tüm işlemler bir tık uzağında!")
            .navigationDestination(for: MenuAction.self ){ action in
                handleMenuAction(action)
            }
        }
    }
    
    
    func handleMenuAction(_ action: MenuAction) -> some View {
        return switch action {
        case .addNewProduct:
            ZStack{}
        case .updateStock:
            ZStack{}
        case .closeToSale:
            ZStack{}
        case .harvestDateEntry:
            ZStack{}
        case .approvalStatus:
            ZStack{}
        case .activeContracts:
            ZStack{}
        case .pendingContracts:
            ZStack{}
        case .contractDetails:
            ZStack{}
        case .productLossInsurance:
            ZStack{}
        case .naturalDisasterInsurance:
            ZStack{}
        case .damageReports:
            ZStack{}
        case .productInsurance:
            ZStack{}
        case .shippingInsurance:
            ZStack{}
        case .warehouseInsurance:
            ZStack{}
        case .manufacturerGuarantee:
            ZStack{}
        case .customerGuarantee:
            ZStack{}
        case .supplierGuaranteeSystem:
            ZStack{}
        case .consumerRights:
            ZStack{}
        case .manufacturerContracts:
            ZStack{}
        case .privacyPolicy:
            ZStack{}
        case .organicCertificate:
            ZStack{}
        case .goodAgriculturalPractices:
            ZStack{}
        case .isoDocuments:
            ZStack{}
        case .pesticideControl:
            ZStack{}
        case .microbiologicalTests:
            ZStack{}
        case .farmInfo:
            ZStack{}
        case .harvestDate:
            ZStack{}
        case .storageConditions:
            ZStack{}
        }
    }

}
