//
//  CheckUserUseCase.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//

import Foundation
import Combine

protocol CheckUserUseCaseProtocol {
    
    func execute() -> AnyPublisher<User, AuthError>
}

final class CheckUserUseCase : CheckUserUseCaseProtocol{
    
    private var cancellables = Set<AnyCancellable>()
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute()-> AnyPublisher<User, AuthError> {
        return repository.getCurrentUser()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
