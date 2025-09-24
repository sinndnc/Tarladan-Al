//
//  DeliveryCard 2.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/23/25.
//
import SwiftUI

struct DeliveryCard: View {
   let delivery: Delivery
   let action: () -> Void
   @State private var isPressed = false
   
   private var dateFormatter: DateFormatter {
       let formatter = DateFormatter()
       formatter.dateFormat = "dd MMM, HH:mm"
       formatter.locale = Locale(identifier: "tr_TR")
       return formatter
   }
   
   private var shortDateFormatter: DateFormatter {
       let formatter = DateFormatter()
       formatter.dateFormat = "dd MMM"
       formatter.locale = Locale(identifier: "tr_TR")
       return formatter
   }
   
   var body: some View {
       Button(action: {
           withAnimation(.easeInOut(duration: 0.1)) {
               action()
           }
       }) {
           VStack(spacing: 0) {
               // Header Section
               HStack(alignment: .top, spacing: 12) {
                   // Status Icon
                   ZStack {
                       Circle()
                           .fill(delivery.status.color.opacity(0.1))
                           .frame(width: 40, height: 40)
                       
                       Image(systemName: delivery.status.icon)
                           .font(.system(size: 16, weight: .medium))
                           .foregroundColor(delivery.status.color)
                   }
                   
                   // Main Info
                   VStack(alignment: .leading, spacing: 6) {
                       HStack {
                           Text(delivery.status.displayName)
                               .font(.subheadline)
                               .fontWeight(.semibold)
                               .foregroundColor(delivery.status.color)
                           
                           Spacer()
                           
                           Text(shortDateFormatter.string(from: delivery.scheduledDeliveryDate))
                               .font(.caption)
                               .fontWeight(.medium)
                               .foregroundColor(.secondary)
                               .padding(.horizontal, 8)
                               .padding(.vertical, 4)
                               .background(Color.gray.opacity(0.1))
                               .clipShape(Capsule())
                       }
                       
                       Text("Sipariş #\(delivery.orderNumber)")
                           .font(.headline)
                           .fontWeight(.semibold)
                           .foregroundColor(.primary)
                       
                       HStack(spacing: 8) {
                           Label("\(delivery.items.count) ürün", systemImage: "cube.box.fill")
                               .font(.caption)
                               .foregroundColor(.secondary)
                           
                           Circle()
                               .fill(Color.secondary)
                               .frame(width: 3, height: 3)
                           
                           Text("\(delivery.totalAmount + delivery.deliveryFee, specifier: "%.2f") ₺")
                               .font(.caption)
                               .fontWeight(.semibold)
                               .foregroundColor(.green)
                       }
                   }
               }
               .padding(.horizontal, 16)
               .padding(.top, 16)
               
               // Items Preview
               if !delivery.items.isEmpty {
                   VStack(alignment: .leading, spacing: 8) {
                      
                       HStack {
                           Text("Ürünler:")
                               .font(.caption)
                               .fontWeight(.medium)
                               .foregroundColor(.secondary)
                           
                           Spacer()
                       }
                       .padding(.horizontal, 16)
                       
                       ScrollView(.horizontal, showsIndicators: false) {
                           HStack(spacing: 8) {
                               ForEach(delivery.items.prefix(3)) { item in
                                   itemPreviewCard(item)
                               }
                               
                               if delivery.items.count > 3 {
                                   moreItemsCard(count: delivery.items.count - 3)
                               }
                           }
                           .padding(.vertical,5)
                           .padding(.horizontal, 16)
                       }
                   }
               }
               
               // Footer Section
               HStack {
                   // Customer Info
                   HStack(spacing: 6) {
                       Image(systemName: "person.circle.fill")
                           .font(.system(size: 14))
                           .foregroundColor(.blue)
                       
                       Text(delivery.customer.name)
                           .font(.caption)
                           .fontWeight(.medium)
                           .foregroundColor(.primary)
                           .lineLimit(1)
                       
                       if delivery.customer.isVipCustomer {
                           Image(systemName: "crown.fill")
                               .font(.system(size: 10))
                               .foregroundColor(.orange)
                       }
                   }
                   
                   Spacer()
                   
                   // Progress Indicator & Arrow
                   HStack(spacing: 8) {
                       // Mini progress bar
                       HStack(spacing: 2) {
                           ForEach(0..<5) { index in
                               Circle()
                                   .fill(Double(index) < delivery.status.progressValue * 5 ?
                                         delivery.status.color : Color.gray.opacity(0.3))
                                   .frame(width: 4, height: 4)
                           }
                       }
                       
                       Image(systemName: "chevron.right")
                           .font(.system(size: 12, weight: .medium))
                           .foregroundColor(.secondary)
                   }
               }
               .padding(.horizontal, 16)
               .padding(.vertical, 12)
               .background(Color.gray.opacity(0.05))
           }
           .background(
               RoundedRectangle(cornerRadius: 16)
                   .fill(.white)
                   .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
           )
           .overlay(
               RoundedRectangle(cornerRadius: 16)
                   .stroke(delivery.status.color.opacity(0.1), lineWidth: 1)
           )
       }
       .buttonStyle(PlainButtonStyle())
   }
   
   private func itemPreviewCard(_ item: DeliveryItem) -> some View {
       VStack(spacing: 4) {
           Text(item.productName)
               .font(.caption2)
               .fontWeight(.medium)
               .foregroundColor(.primary)
               .lineLimit(1)
           
           Text("\(item.quantity, specifier: "%.0f") \(item.unit)")
               .font(.system(size: 10))
               .foregroundColor(.secondary)
           
           Spacer()
           
           if item.isTemperatureSensitive {
               Image(systemName: "thermometer")
                   .font(.system(size: 8))
                   .foregroundColor(.blue)
           }
       }
       .padding(.horizontal, 8)
       .padding(.vertical, 6)
   }
   
   private func moreItemsCard(count: Int) -> some View {
       VStack(spacing: 4) {
           Text("+\(count)")
               .font(.caption)
               .fontWeight(.bold)
               .foregroundColor(.orange)
           
           Text("diğer")
               .font(.system(size: 10))
               .foregroundColor(.secondary)
       }
       .padding(.horizontal, 8)
       .padding(.vertical, 6)
       .background(Color.orange.opacity(0.05))
       .clipShape(RoundedRectangle(cornerRadius: 6))
       .overlay(
           RoundedRectangle(cornerRadius: 6)
               .stroke(Color.orange.opacity(0.2), lineWidth: 1)
       )
   }
}
