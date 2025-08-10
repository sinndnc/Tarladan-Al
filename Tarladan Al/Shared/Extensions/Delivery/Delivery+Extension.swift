//
//  SwiftUIView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation
import FirebaseCore

extension Delivery {
    
    func toDeliveryDTO() -> DeliveryDTO {
        return DeliveryDTO(
            id: id,
            orderNumber: orderNumber,
            customerId: customer.id,
            customerName: customer.name,
            customerEmail: customer.email,
            customerPhone: customer.phone,
            deliveryAddress: customer.address,
            items: items.map { $0.toDeliveryItemDTO() },
            status: status.rawValue,
            createdAt: Timestamp(date: createdAt),
            scheduledDeliveryDate: Timestamp(date: scheduledDeliveryDate),
            actualDeliveryDate: actualDeliveryDate != nil ? Timestamp(date: actualDeliveryDate!) : nil,
            totalAmount: totalAmount,
            deliveryFee: deliveryFee,
            specialInstructions: specialInstructions,
            driverNotes: driverNotes,
            currentLatitude: currentLocation?.latitude,
            currentLongitude: currentLocation?.longitude
        )
    }
}
