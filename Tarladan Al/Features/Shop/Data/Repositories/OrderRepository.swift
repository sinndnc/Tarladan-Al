//
//  OrderRepository.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/30/25.
//

import Foundation
import Combine

final class OrderRepository : OrderRepositoryProtocol {
    private let remoteDataSource: OrderRemoteDataSourceProtocol
    
    init(
        remoteDataSource: OrderRemoteDataSourceProtocol,
    ) {
        self.remoteDataSource = remoteDataSource
    }
    
    func create(order: Order) -> AnyPublisher<String, OrderError> {
        remoteDataSource.createOrderOfUser(order: order)
            .mapError { error in
                Logger.log("❌ REPOSITORY ERROR: \(error)")
                return OrderError.unkownError
            }
            .eraseToAnyPublisher()
    }
    
    func listenOfUser(for userId: String) -> AnyPublisher<[Order], OrderError> {
        remoteDataSource.listenOrderOfUser(userId: userId)
            .mapError { error in
                Logger.log("❌ REPOSITORY ERROR: \(error)")
                return OrderError.unkownError
            }
            .eraseToAnyPublisher()
    }
    
}
