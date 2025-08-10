//
//  UpdateDeliveryStatusUseCase.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/6/25.
//

import Foundation

protocol UpdateDeliveryStatusUseCaseProtocol{
    
    func execute(deliveryId: String, newStatus: DeliveryStatus)
    
}

final class UpdateDeliveryStatusUseCase : UpdateDeliveryStatusUseCaseProtocol{
    private let repository: DeliveryRepositoryProtocol
    
    init(repository: DeliveryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(deliveryId: String, newStatus: DeliveryStatus) {
        // Business rules for status transitions
//        guard let currentDelivery = repository.getDeliveryById(deliveryId) else {
//            throw DeliveryError.deliveryNotFound
//        }
//        
//        guard isValidStatusTransition(from: currentDelivery.status, to: newStatus) else {
//            throw DeliveryError.invalidStatusTransition
//        }
//        
//        try await repository.updateDeliveryStatus(deliveryId, status: newStatus)
    }
    
    private func isValidStatusTransition(from currentStatus: DeliveryStatus, to newStatus: DeliveryStatus) -> Bool {
        switch (currentStatus, newStatus) {
        case (.pending, .confirmed), (.pending, .cancelled):
            return true
        case (.confirmed, .preparing), (.confirmed, .cancelled):
            return true
        case (.preparing, .inTransit), (.preparing, .cancelled):
            return true
        case (.inTransit, .delivered):
            return true
        default:
            return false
        }
    }
}
