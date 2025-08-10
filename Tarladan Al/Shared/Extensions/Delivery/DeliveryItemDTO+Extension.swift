//
//  DeliveryItemDTO+Extension.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//



extension DeliveryItemDTO {
    
    func toDeliveryItem() -> DeliveryItem {
        return DeliveryItem(
            id: id,
            productName: productName,
            productId: productId,
            quantity: quantity,
            unit: unit,
            pricePerUnit: pricePerUnit,
            isTemperatureSensitive: isTemperatureSensitive,
            requiredTemperature: requiredTemperature
        )
    }
}
