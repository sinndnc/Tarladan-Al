//
//  ProductRepository.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//
import Foundation
import Combine

class ProductRepository: ProductRepositoryProtocol {
    private let remoteDataSource: ProductRemoteDataSourceProtocol
    
    init(
        remoteDataSource: ProductRemoteDataSourceProtocol,
    ) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getProductById(id: String) -> AnyPublisher<Product, ProductError> {
        return remoteDataSource.getProductById(id: id)
            .mapError { error in
                Logger.log("❌ REPOSITORY ERROR: \(error)")
                return ProductError.emptyItems
            }
            .eraseToAnyPublisher()
    }
    
    func listenProducts() -> AnyPublisher<[Product], ProductError> {
        return remoteDataSource.listenToProducts()
            .mapError { error in
                Logger.log("❌ REPOSITORY ERROR: \(error)")
                return ProductError.emptyItems
            }
            .eraseToAnyPublisher()
    }
    
}
