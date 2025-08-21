//
//  UserRepository.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//

import Foundation
import Combine
import FirebaseFirestore

final class UserRepository : UserRepositoryProtocol {
    
    private let remoteDataSource: UserRemoteDataSourceProtocol
    
    init(
        remoteDataSource: UserRemoteDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
    }
    
    func listenUserById(_ id: String) -> AnyPublisher<User, UserError> {
        return remoteDataSource.listenUserById(id)
            .map { user in
                return user
            }
            .mapError { error in
                Logger.log("❌ Repository hatası: \(error)")
                return UserError.internalError
            }
            .eraseToAnyPublisher()
    }
    
    func updateDefaultAddress(_ id: String, _ addressId: String) -> AnyPublisher<Void, UserError> {
        return remoteDataSource.updateDefaultAddress(id: id, addressId: addressId)
            .mapError { error in
                Logger.log(error.localizedDescription)
                return UserError.internalError
            }
            .eraseToAnyPublisher()
    }
    
    
    func addToFavorites(id: String, data: [String: Any]) -> AnyPublisher<Void,UserError>{
        
        return remoteDataSource.addToFavorites(id: id, data: data)
            .handleEvents(
                receiveSubscription: { _ in
                    Logger.log("📡 REPOSITORY: Subscribed to remote data source")
                },
                receiveOutput: { _ in
                    Logger.log("📥 REPOSITORY: Received ")
                }
            )
            .mapError { error in
                Logger.log("❌ REPOSITORY ERROR: \(error)")
                return UserError.internalError
            }
            .eraseToAnyPublisher()
    }
}
