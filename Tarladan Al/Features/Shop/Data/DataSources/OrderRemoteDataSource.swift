//
//  OrderRemoteDataSource.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/30/25.
//

import Combine
import Foundation
import FirebaseFirestore

protocol OrderRemoteDataSourceProtocol{
    func createOrderOfUser(order: Order) -> AnyPublisher<String, BaseServiceError<FirebaseManager<Order>>>
    func listenOrderOfUser(userId: String) -> AnyPublisher<[Order], BaseServiceError<FirebaseManager<Order>>>
}

final class OrderRemoteDataSource: FirebaseManager<Order> ,OrderRemoteDataSourceProtocol{
    
    private let collection = FirebaseConstants.orders
    
    init(db: Firestore) {
        super.init(collectionName: collection)
    }
    
    func createOrderOfUser(order: Order) -> AnyPublisher<String, BaseServiceError<FirebaseManager<Order>>>{
        self.create(order)
            .eraseToAnyPublisher()
    }
    
    
    func listenOrderOfUser(userId: String) -> AnyPublisher<[Order], BaseServiceError<FirebaseManager<Order>>> {
        self.listen(where: FirebaseConstants.owner_id, isEqualTo: userId)
    }
}
