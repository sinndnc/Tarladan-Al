//
//  DeliveryMapCard.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/23/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct DeliveryMapCard: View {
    @State private var showingFullScreenMap = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784), // İstanbul
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    // Örnek teslimat konumları
    @State private var deliveryLocations: [DeliveryLocation] = [
        DeliveryLocation(
            id: "1",
            title: "Aktif Teslimat",
            subtitle: "Kadıköy, İstanbul",
            coordinate: CLLocationCoordinate2D(latitude: 40.9903, longitude: 29.0275),
            status: .inTransit
        ),
        DeliveryLocation(
            id: "2",
            title: "Teslim Edildi",
            subtitle: "Beşiktaş, İstanbul",
            coordinate: CLLocationCoordinate2D(latitude: 41.0425, longitude: 29.0095),
            status: .delivered
        ),
        DeliveryLocation(
            id: "3",
            title: "Hazırlanıyor",
            subtitle: "Üsküdar, İstanbul",
            coordinate: CLLocationCoordinate2D(latitude: 41.0242, longitude: 29.0158),
            status: .preparing
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Teslimat Haritası")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("3 aktif teslimat takip ediliyor")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button {
                    showingFullScreenMap = true
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            
            // Mini Map
            ZStack {
                if #available(iOS 17.0, *) {
                    Map(initialPosition: .region(region)) {
                        ForEach(deliveryLocations) { location in
                            Annotation("", coordinate: location.coordinate) {
                                DeliveryMapPin(location: location)
                            }
                            .annotationTitles(.hidden)
                        }
                    }
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .allowsHitTesting(false) // Mini haritada touch disable
                } else {
                    Map(coordinateRegion: .constant(region), annotationItems: deliveryLocations) { location in
                        MapAnnotation(coordinate: location.coordinate) {
                            DeliveryMapPin(location: location)
                        }
                    }
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .allowsHitTesting(false) // Mini haritada touch disable
                }
                
                // Overlay tap area
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showingFullScreenMap = true
                    }
                
                // Status overlay
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.caption2)
                                .foregroundColor(.blue)
                            Text("Haritayı genişlet")
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.1), radius: 4)
                        )
                        .padding(.trailing, 16)
                        .padding(.bottom, 16)
                    }
                }
            }
            
            // Quick Stats
            HStack(spacing: 16) {
                MapStatItem(
                    title: "Aktif",
                    count: deliveryLocations.filter { $0.status == .inTransit }.count,
                    color: .orange
                )
                
                MapStatItem(
                    title: "Hazır",
                    count: deliveryLocations.filter { $0.status == .preparing }.count,
                    color: .blue
                )
                
                MapStatItem(
                    title: "Teslim",
                    count: deliveryLocations.filter { $0.status == .delivered }.count,
                    color: .green
                )
                
                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
        .fullScreenCover(isPresented: $showingFullScreenMap) {
            FullScreenMapView(
                deliveryLocations: deliveryLocations,
                initialRegion: region
            )
        }
    }
}

// MARK: - Delivery Location Model
struct DeliveryLocation: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let coordinate: CLLocationCoordinate2D
    let status: DeliveryStatus
}


// MARK: - Map Pin
struct DeliveryMapPin: View {
    let location: DeliveryLocation
    
    var body: some View {
        ZStack {
            Circle()
                .fill(location.status.color)
                .frame(width: 24, height: 24)
            
            Image(systemName: location.status.icon)
                .font(.caption)
                .foregroundColor(.white)
                .fontWeight(.semibold)
        }
        .shadow(color: location.status.color.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Map Stat Item
struct MapStatItem: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("\(count)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Full Screen Map View
struct FullScreenMapView: View {
    let deliveryLocations: [DeliveryLocation]
    @State var region: MKCoordinateRegion
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLocation: DeliveryLocation?
    
    init(deliveryLocations: [DeliveryLocation], initialRegion: MKCoordinateRegion) {
        self.deliveryLocations = deliveryLocations
        self._region = State(initialValue: initialRegion)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if #available(iOS 17.0, *) {
                    Map(initialPosition: .region(region)) {
                        ForEach(deliveryLocations) { location in
                            Annotation("", coordinate: location.coordinate) {
                                Button {
                                    selectedLocation = location
                                } label: {
                                    VStack(spacing: 4) {
                                        ZStack {
                                            Circle()
                                                .fill(location.status.color)
                                                .frame(width: 36, height: 36)
                                            
                                            Image(systemName: location.status.icon)
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                        }
                                        .shadow(color: location.status.color.opacity(0.3), radius: 8, x: 0, y: 4)
                                        
                                        // Location label
                                        Text(location.title)
                                            .font(.caption2)
                                            .fontWeight(.medium)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(Color(.systemBackground))
                                                    .shadow(color: .black.opacity(0.1), radius: 2)
                                            )
                                    }
                                }
                            }
                            .annotationTitles(.hidden)
                        }
                    }
                    .ignoresSafeArea()
                } else {
                    Map(
                        coordinateRegion: $region,
                        annotationItems: deliveryLocations
                    ) { location in
                        MapAnnotation(coordinate: location.coordinate) {
                            Button {
                                selectedLocation = location
                            } label: {
                                VStack(spacing: 4) {
                                    ZStack {
                                        Circle()
                                            .fill(location.status.color)
                                            .frame(width: 36, height: 36)
                                        
                                        Image(systemName: location.status.icon)
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                    }
                                    .shadow(color: location.status.color.opacity(0.3), radius: 8, x: 0, y: 4)
                                    
                                    // Location label
                                    Text(location.title)
                                        .font(.caption2)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color(.systemBackground))
                                                .shadow(color: .black.opacity(0.1), radius: 2)
                                        )
                                }
                            }
                        }
                    }
                    .ignoresSafeArea()
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
                        
                        // Map Type Selector (optional)
                        Button {
                            // Toggle map type
                        } label: {
                            Image(systemName: "map")
                                .font(.title3)
                                .foregroundStyle(.secondary, .regularMaterial)
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                
                // Bottom Sheet for Selected Location
                if let selectedLocation = selectedLocation {
                    VStack {
                        Spacer()
                        LocationDetailSheet(location: selectedLocation) {
                            self.selectedLocation = nil
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .navigationBarHidden(true)
        }
        .animation(.easeInOut(duration: 0.3), value: selectedLocation?.id)
    }
}

// MARK: - Location Detail Sheet
struct LocationDetailSheet: View {
    let location: DeliveryLocation
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Handle
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(.systemGray4))
                .frame(width: 36, height: 4)
                .padding(.top, 8)
            
            // Content
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(location.status.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: location.status.icon)
                        .font(.title3)
                        .foregroundColor(location.status.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(location.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text(statusText(for: location.status))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(location.status.color)
                        
                        Spacer()
                        
                        Button("Detaylar") {
                            onDismiss()
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
        )
        .padding(.horizontal, 16)
        .onTapGesture {
            onDismiss()
        }
    }
    
    private func statusText(for status: DeliveryStatus) -> String {
        switch status {
        case .preparing: return "Hazırlanıyor"
        case .inTransit: return "Yolda"
        case .delivered: return "Teslim Edildi"
        case .cancelled: return "İptal Edildi"
        case .confirmed: return "Onaylandı"
        case .pending: return "Bekleniyor"
        }
    }
}
