//
//  CreateOrderUseCase.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/30/25.
//

import Foundation
import Combine

protocol CreateOrderUseCaseProtocol{
    
    func execute(order: Order) -> AnyPublisher<String, OrderError>
}

final class CreateOrderUseCase : CreateOrderUseCaseProtocol{
    private let repository: OrderRepositoryProtocol
    
    init(repository: OrderRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(order: Order) -> AnyPublisher<String, OrderError>{
        return repository.create(order: order)
            .eraseToAnyPublisher()
    }
}
