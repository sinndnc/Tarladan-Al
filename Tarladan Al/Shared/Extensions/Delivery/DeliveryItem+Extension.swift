//
//  DeliveryItem+Extension.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//



extension DeliveryItem {
    
    func toDeliveryItemDTO() -> DeliveryItemDTO {
        return DeliveryItemDTO(
            id: id,
            productName: productName,
            productId: productId,
            quantity: quantity,
            unit: unit,
            pricePerUnit: pricePerUnit,
            totalPrice: totalPrice,
            isTemperatureSensitive: isTemperatureSensitive,
            requiredTemperature: requiredTemperature
        )
    }
}
