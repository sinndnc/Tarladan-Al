//
//  DeliveryDTO+Extension.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//

import Foundation
import FirebaseFirestore

extension DeliveryDTO {
    
    func toDelivery() -> Delivery {
        // Customer oluşturma
        let customer = Customer(
            id: customerId,
            name: customerName,
            email: customerEmail,
            phone: customerPhone,
            address: deliveryAddress
        )
        
        // DeliveryItem'ları dönüştürme
        let deliveryItems = items.map { $0.toDeliveryItem() }
        
        // DeliveryStatus dönüştürme
        let deliveryStatus = DeliveryStatus.RawValue(status)
        // GeoPoint oluşturma (eğer koordinatlar varsa)
        var geoPoint: GeoPoint?
        if let lat = currentLatitude, let lng = currentLongitude {
            geoPoint = GeoPoint(latitude: lat, longitude: lng)
        }
        
        // Delivery oluşturma
        var delivery = Delivery(
            orderNumber: orderNumber,
            customer: customer,
            items: deliveryItems,
            status: deliveryStatus.toDeliveryStatus(),
            createdAt: createdAt.dateValue(),
            scheduledDeliveryDate: scheduledDeliveryDate.dateValue(),
            deliveryFee: deliveryFee,
            specialInstructions: specialInstructions
        )
        
        // Mutable property'leri set etme
        delivery.actualDeliveryDate = actualDeliveryDate?.dateValue()
        delivery.driverNotes = driverNotes
        delivery.currentLocation = geoPoint
        
        return delivery
    }
}


