//
//  DeliveryFullScreenMapView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/24/25.
//
import SwiftUI
import MapKit
import CoreLocation

struct SingleAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

// MARK: - Full Screen Map View
struct DeliveryFullScreenMapView: View {
    let delivery: Delivery
    @Environment(\.dismiss) private var dismiss
    @State private var region: MKCoordinateRegion
    
    init(delivery: Delivery) {
        self.delivery = delivery
        
        if let location = delivery.currentLocation {
            self._region = State(initialValue: MKCoordinateRegion(
                center: location.toLocation2D,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
        } else {
            // Default to Istanbul
            self._region = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            ))
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if let currentLocation = delivery.currentLocation {
                    Map(
                        coordinateRegion: $region,
                        annotationItems: [SingleAnnotation(coordinate: currentLocation.toLocation2D)]
                    ) { item in
                        MapPin(
                            coordinate: item.coordinate,
                            tint: delivery.status.color
                        )
                    }
                    .ignoresSafeArea()
                } else {
                    Map(coordinateRegion: $region)
                        .ignoresSafeArea()
                        .overlay(
                            VStack {
                                Text("Konum bilgisi henüz mevcut değil")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        )
                }
                
                // Top Controls
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.secondary, .regularMaterial)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("#\(delivery.orderNumber)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(delivery.status.color)
                                    .frame(width: 6, height: 6)
                                Text(delivery.status.displayName)
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding()
                    
                    Spacer()
                }
                
                // Bottom Info Sheet
                VStack {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        // Handle
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(.systemGray4))
                            .frame(width: 36, height: 4)
                        
                        // Content
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(delivery.status.color.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: delivery.status.icon)
                                    .font(.title3)
                                    .foregroundColor(delivery.status.color)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Sipariş #\(delivery.orderNumber)")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text(delivery.customer.address.fullAddress)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                                
                                HStack(spacing: 12) {
                                    Text(delivery.status.displayName)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(delivery.status.color)
                                    
                                    if delivery.status == .inTransit {
                                        Text("•")
                                            .foregroundColor(.secondary)
                                        Text("15-25 dk kaldı")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.orange)
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 34)
                    .background(.regularMaterial)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
