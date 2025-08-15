//
//  ListenProductsUseCase.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//

import Foundation
import Combine


protocol ListenProductsUseCaseProtocol{
    
    func execute() -> AnyPublisher<[Product], ProductError>
}

final class ListenProductsUseCase : ListenProductsUseCaseProtocol{
    private let repository: ProductRepositoryProtocol
    
    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Product], ProductError>{
        return repository.listenProducts()
            .eraseToAnyPublisher()
    }
}
