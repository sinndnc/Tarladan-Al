//
//  ListenUserUseCase.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//

import Foundation
import Combine


protocol ListenUserUseCaseProtocol {
    func execute(by id: String) -> AnyPublisher<User,UserError>
}

final class ListenUserUseCase : ListenUserUseCaseProtocol{
    
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(by id: String) -> AnyPublisher<User, UserError> {
        return repository.listenUserById(id)
            .handleEvents(
                receiveOutput: { user in
                },
                receiveCompletion: { completion in
                }
            )
            .eraseToAnyPublisher()
    }
}
