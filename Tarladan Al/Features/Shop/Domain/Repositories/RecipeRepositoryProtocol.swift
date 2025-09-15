//
//  RecipeRepositoryProtocol.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/15/25.
//

import Foundation
import Combine

protocol RecipeRepositoryProtocol {
    
    func listenRecipes() -> AnyPublisher<[Recipe], RecipeError>
    
}
