//
//  UserRepositoryProtocol.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//

import Foundation
import Combine

protocol UserRepositoryProtocol{
//    func getAllUsers()-> AnyPublisher<[User],UserError>
    func listenUserById(_ id: String)  -> AnyPublisher<User,UserError>
//    func createUser(_ user: User)  -> AnyPublisher<User,UserError>
//    func updateUser(_ user: User) -> AnyPublisher<User,UserError>
//    func deleteUser(_ id: String)
}
