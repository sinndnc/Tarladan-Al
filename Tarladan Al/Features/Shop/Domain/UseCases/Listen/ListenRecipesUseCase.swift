//
//  ListenRecipesUseCase.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/15/25.
//

import Foundation
import Combine


protocol ListenRecipesUseCaseProtocol{
    
    func execute() -> AnyPublisher<[Recipe], RecipeError>
}

final class ListenRecipesUseCase : ListenRecipesUseCaseProtocol{
    
    private let repository: RecipeRepositoryProtocol
    
    init(repository: RecipeRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Recipe], RecipeError>{
        return repository.listenRecipes()
            .eraseToAnyPublisher()
    }
}

