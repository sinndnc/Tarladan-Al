//
//  DeliveryTrackingView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/12/25.
//
import SwiftUI

struct TrackingStep {
    let title: String
    let description: String
    let time: Date
    let isCompleted: Bool
    let icon: String
}

struct DeliveryTrackingView: View {
    let delivery: Delivery
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Int = 0
    
    private var trackingSteps: [TrackingStep] {
        var steps: [TrackingStep] = []
        
        steps.append(TrackingStep(
            title: "Sipariş Alındı",
            description: "Siparişiniz başarıyla alındı ve işleme konuldu",
            time: delivery.createdAt,
            isCompleted: true,
            icon: "checkmark.circle.fill"
        ))
        
        if delivery.status.rawValue >= DeliveryStatus.preparing.rawValue {
            steps.append(TrackingStep(
                title: "Hazırlanıyor",
                description: "Siparişiniz hazırlanıyor",
                time: Calendar.current.date(byAdding: .minute, value: 15, to: delivery.createdAt) ?? delivery.createdAt,
                isCompleted: true,
                icon: "gear.circle.fill"
            ))
        }
        
        if delivery.status.rawValue >= DeliveryStatus.inTransit.rawValue {
            steps.append(TrackingStep(
                title: "Yolda",
                description: "Siparişiniz size doğru yola çıktı",
                time: Calendar.current.date(byAdding: .minute, value: 30, to: delivery.createdAt) ?? delivery.createdAt,
                isCompleted: true,
                icon: "truck.box.fill"
            ))
        }
        
        if delivery.status == .delivered, let deliveredDate = delivery.actualDeliveryDate {
            steps.append(TrackingStep(
                title: "Teslim Edildi",
                description: "Siparişiniz başarıyla teslim edildi",
                time: deliveredDate,
                isCompleted: true,
                icon: "checkmark.circle.fill"
            ))
        }
        
        return steps
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    headerSection
                    
                    // Current Status Card
                    currentStatusCard
                    
                    // Tracking Timeline
                    trackingTimeline
                    
                    // Estimated Time
                    estimatedTimeSection
                    
                    // Contact Section
                    contactSection
                }
                .padding()
            }
            .navigationTitle("Sipariş Takip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sipariş #\(delivery.orderNumber)")
                .font(.title2)
                .fontWeight(.bold)
            Text(delivery.customer.address.fullAddress)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var currentStatusCard: some View {
        VStack(spacing: 16) {
            Image(systemName: delivery.status.icon)
                .font(.system(size: 50))
                .foregroundColor(delivery.status.color)
            
            Text(delivery.status.rawValue)
                .font(.title2)
                .fontWeight(.semibold)
            
            if delivery.status == .inTransit {
                Text("Tahmini kalan süre: 15-25 dk")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(delivery.status.color.opacity(0.1))
        .cornerRadius(16)
    }
    
    private var trackingTimeline: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Sipariş Durumu")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom)
            
            ForEach(Array(trackingSteps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 12) {
                    VStack {
                        Image(systemName: step.icon)
                            .font(.title3)
                            .foregroundColor(step.isCompleted ? .green : .gray)
                            .frame(width: 30, height: 30)
                            .background(Circle().fill(step.isCompleted ? Color.green.opacity(0.1) : Color.gray.opacity(0.1)))
                        
                        if index < trackingSteps.count - 1 {
                            Rectangle()
                                .fill(step.isCompleted ? Color.green : Color.gray.opacity(0.3))
                                .frame(width: 2, height: 40)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text(step.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if step.isCompleted {
                            Text(DateFormatter.trackingFormatter.string(from: step.time))
                                .font(.caption2)
                                .foregroundColor(.green)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2)
    }
    
    private var estimatedTimeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Teslimat Bilgileri")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                    Text("Planlanan Teslimat:")
                    Spacer()
                    Text(DateFormatter.shortFormatter.string(from: delivery.scheduledDeliveryDate))
                        .fontWeight(.medium)
                }
                
                if delivery.status == .inTransit {
                    HStack {
                        Image(systemName: "timer")
                            .foregroundColor(.orange)
                        Text("Tahmini Varış:")
                        Spacer()
                        Text("15-25 dk")
                            .fontWeight(.medium)
                            .foregroundColor(.orange)
                    }
                }
            }
            .font(.subheadline)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2)
    }
    
    private var contactSection: some View {
        VStack(spacing: 12) {
            Button(action: {
                if let url = URL(string: "tel:\(delivery.customer.phone)") {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack {
                    Image(systemName: "phone.fill")
                    Text("Müşteriyi Ara")
                }
                .font(.subheadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
            }
            
            Button(action: {
                // Support contact action
            }) {
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                    Text("Destek")
                }
                .font(.subheadline)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
}
