//
//  RecipeRepository.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/15/25.
//

import Foundation
import Combine

final class RecipeRepository : RecipeRepositoryProtocol{
    
    private let remoteDataSource: RecipeRemoteDataSourceProtocol
    
    init(
        remoteDataSource: RecipeRemoteDataSourceProtocol,
    ) {
        self.remoteDataSource = remoteDataSource
    }
    
    func listenRecipes() -> AnyPublisher<[Recipe], RecipeError> {
        return remoteDataSource.listenRecipes()
            .mapError { error in
                Logger.log("❌ REPOSITORY ERROR: \(error)")
                return RecipeError.unkownError
            }
            .eraseToAnyPublisher()
    }
    
}
