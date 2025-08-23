//
//  AddToFavoritesUseCase.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/21/25.
//

import Foundation
import Combine

protocol AddToFavoritesUseCaseProtocol{
    
    func execute(id: String, productId: String) -> AnyPublisher<Void, UserError>
    
}

final class AddToFavoritesUseCase : AddToFavoritesUseCaseProtocol{
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: String, productId: String) -> AnyPublisher<Void, UserError>{
        return repository.addToFavorites(id: id,productId: productId)
            .eraseToAnyPublisher()
    }
}
