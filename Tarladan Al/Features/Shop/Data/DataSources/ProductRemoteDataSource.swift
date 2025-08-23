//
//  ProductRemoteDataSourceProtocol.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//
import FirebaseFirestore
import Combine

protocol ProductRemoteDataSourceProtocol{
    func listenToProducts() -> AnyPublisher<[Product], BaseServiceError<FirebaseManager<Product>>>
    func getProductById(id: String) -> AnyPublisher<Product, BaseServiceError<FirebaseManager<Product>>>
}

final class ProductRemoteDataSource: FirebaseManager<Product> ,ProductRemoteDataSourceProtocol{
    
    private let collection = FirebaseConstants.products
    
    init(db: Firestore) {
        super.init(collectionName: collection)
    }
    
    func getProductById(id: String) -> AnyPublisher<Product, BaseServiceError<FirebaseManager<Product>>> {
        self.listen(id: id)
            .eraseToAnyPublisher()
    }
    
    func listenToProducts() -> AnyPublisher<[Product], BaseServiceError<FirebaseManager<Product>>> {
        self.listen()
            .eraseToAnyPublisher()
    }
    
}
