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
    
    func listenProducts() -> AnyPublisher<[Product], ProductError> {
        Logger.log("🚀 REPOSITORY: Starting to listen products")
        
        return remoteDataSource.listenToProducts()
            .handleEvents(
                receiveSubscription: { _ in
                    Logger.log("📡 REPOSITORY: Subscribed to remote data source")
                },
                receiveOutput: { products in
                    Logger.log("📥 REPOSITORY: Received \(products.count) products")
                }
            )
            .mapError { error in
                Logger.log("❌ REPOSITORY ERROR: \(error)")
                return ProductError.emptyItems
            }
            .eraseToAnyPublisher()
    }
    
}
