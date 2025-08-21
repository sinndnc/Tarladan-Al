//
//  UpdateDefaultAddress.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/20/25.
//

import Foundation
import Combine

protocol UpdateDefaultAddressUseCaseProtocol {
    func execute(of id: String,for addressId: String) -> AnyPublisher<Void, UserError>
}

final class UpdateDefaultAddressUseCase: UpdateDefaultAddressUseCaseProtocol {
    
    // MARK: - Properties
    private let repository: UserRepositoryProtocol
    
    // MARK: - Initialization
    init(
        repository: UserRepositoryProtocol
    ) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    func execute(of id: String,for addressId: String) -> AnyPublisher<Void, UserError>{
        repository.updateDefaultAddress(id, addressId)
            .eraseToAnyPublisher()
    }
    
}
