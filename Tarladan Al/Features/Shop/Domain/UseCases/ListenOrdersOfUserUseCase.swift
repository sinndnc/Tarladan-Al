//
//  ListenOrdersOfUser.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/2/25.
//

import Foundation
import Combine

protocol ListenOrdersOfUserUseCaseProtocol{
    
    func execute(of userId: String) -> AnyPublisher<[Order], OrderError>
}

final class ListenOrdersOfUserUseCase : ListenOrdersOfUserUseCaseProtocol{
    private let repository: OrderRepositoryProtocol
    
    init(repository: OrderRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(of userId: String) -> AnyPublisher<[Order], OrderError> {
        return repository.listenOfUser(for: userId)
            .eraseToAnyPublisher()
    }
}
