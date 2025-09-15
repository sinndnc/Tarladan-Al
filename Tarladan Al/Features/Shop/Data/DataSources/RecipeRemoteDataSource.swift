//
//  RecipeRemoteDataSource.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/15/25.
//

import Foundation
import FirebaseFirestore
import Combine

protocol RecipeRemoteDataSourceProtocol{
    func listenRecipes() -> AnyPublisher<[Recipe], BaseServiceError<FirebaseManager<Recipe>>>
}

final class RecipeRemoteDataSource: FirebaseManager<Recipe> ,RecipeRemoteDataSourceProtocol{
    
    private let collection = FirebaseConstants.recipes
    
    init(db: Firestore) {
        super.init(collectionName: collection)
    }
    
    func listenRecipes() -> AnyPublisher<[Recipe], BaseServiceError<FirebaseManager<Recipe>>>{
        self.listen()
            .eraseToAnyPublisher()
    }
}
