//
//  GetDeliveriesUseCase.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/6/25.
//

import Foundation
import Combine

protocol ListenDeliveriesUseCaseProtocol {
    func execute() -> AnyPublisher<[Delivery], DeliveryError>
}

final class ListenDeliveriesUseCase : ListenDeliveriesUseCaseProtocol{
    private let repository: DeliveryRepositoryProtocol
    
    init(repository: DeliveryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Delivery], DeliveryError>{
        return repository.listenDeliveries()
    }
}
