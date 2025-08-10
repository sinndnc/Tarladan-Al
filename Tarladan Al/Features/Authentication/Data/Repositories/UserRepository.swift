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
    
//    func getAllUsers() -> AnyPublisher<[User], UserError> {
//       return remoteDataSource.getAllUsers()
//            .tryMap { users in
//                return users
//            }
//            .mapError { error in
//                if let UserError = error as? UserError {
//                    return UserError
//                }
//                return UserError.internalError
//            }
//            .eraseToAnyPublisher()
//    }
    
    func listenUserById(_ id: String) -> AnyPublisher<User, UserError> {
        return remoteDataSource.listenUserById(id)
            .map { user in
                Logger.log("REPOSITORY: \(user)")
                return user
            }
            .mapError { error in
                Logger.log("❌ Repository hatası: \(error)")
                return UserError.internalError
            }
            .eraseToAnyPublisher()
    }
    
//
//    func createUser(_ user: User) -> AnyPublisher<User, UserError> {
//        return remoteDataSource.createUser(user)
//            .tryMap { user in
//                return user
//            }
//            .mapError { error in
//                if let UserError = error as? UserError {
//                    return UserError
//                }
//                return UserError.internalError
//            }
//            .eraseToAnyPublisher()
//    }
//    
//    func updateUser(_ user: User) -> AnyPublisher<User, UserError> {
//        return remoteDataSource.updateUser(user)
//             .tryMap { user in
//                 return user
//             }
//             .mapError { error in
//                 if let UserError = error as? UserError {
//                     return UserError
//                 }
//                 return UserError.internalError
//             }
//             .eraseToAnyPublisher()
//    }
//    
//    func deleteUser(_ id: String) {
//        return remoteDataSource.deleteUser(id)
//    }
    
}
