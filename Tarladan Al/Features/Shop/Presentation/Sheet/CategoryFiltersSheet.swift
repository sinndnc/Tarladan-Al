//
//  CategoryFiltersSheet.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//
import SwiftUI

struct CategoryFiltersSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ShopViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Sıralama Seçenekleri")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 12) {
//                        ForEach(viewModel.sortOptions, id: \.self) { option in
//                            Button(action: {
//                                viewModel.updateSortOption(option)
//                            }) {
//                                HStack {
//                                    Text(option.rawValue)
//                                        .font(.system(size: 16))
//                                        .foregroundColor(.primary)
//                                    
//                                    Spacer()
//                                    
//                                    if viewModel.sortOption == option {
//                                        Image(systemName: "checkmark")
//                                            .foregroundColor(.green)
//                                            .font(.system(size: 16, weight: .semibold))
//                                    }
//                                }
//                                .padding(.horizontal, 16)
//                                .padding(.vertical, 12)
//                                .background(Color(.systemGray6))
//                                .cornerRadius(12)
//                            }
//                        }
                    }
                }
                
                Spacer()
            }
            .padding(20)
            .navigationTitle("Filtreler")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Uygula") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                }
            }
        }
    }
}
