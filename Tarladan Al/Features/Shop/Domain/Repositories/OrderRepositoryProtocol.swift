//
//  OrderRepositoryProtocol.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/30/25.
//

import Foundation
import Combine

protocol OrderRepositoryProtocol {
    
    func create(order: Order) -> AnyPublisher<String, OrderError> 
    func listenOfUser(for userId: String) -> AnyPublisher<[Order], OrderError>
    
}
