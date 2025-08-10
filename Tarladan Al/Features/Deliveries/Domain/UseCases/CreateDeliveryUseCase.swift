//
//  CreateDeliveryUseCase.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/6/25.
//

import Foundation

protocol CreateDeliveryUseCaseProtocol{
    
    func execute(_ delivery: Delivery) async throws -> Delivery 
}

final class CreateDeliveryUseCase : CreateDeliveryUseCaseProtocol{
    private let repository: DeliveryRepositoryProtocol
    
    init(repository: DeliveryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ delivery: Delivery) async throws -> Delivery {
        // Business logic validations
        guard !delivery.items.isEmpty else {
            throw DeliveryError.emptyItems
        }
        
        guard delivery.scheduledDeliveryDate > Date() else {
            throw DeliveryError.invalidDeliveryDate
        }
        
        return try await repository.createDelivery(delivery)
    }
}
