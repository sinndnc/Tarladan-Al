//
//  DetailTemplateView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/25/25.
//
import SwiftUI

struct DetailTemplateView: View {
    let title: String
    let icon: String
    let content: String
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(systemName: icon)
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Detay Sayfası")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Açıklama")
                            .font(.headline)
                        
                        Text(content)
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Divider()
                        
                        Text("Bu sayfa geliştirilme aşamasındadır. Yakında daha detaylı özellikler eklenecektir.")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
