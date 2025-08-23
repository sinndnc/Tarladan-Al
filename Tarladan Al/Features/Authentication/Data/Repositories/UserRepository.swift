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
    
    private let userRemoteDataSource: UserRemoteDataSourceProtocol
    private let productRemoteDataSource: ProductRemoteDataSourceProtocol
    
    init(
        userRemoteDataSource: UserRemoteDataSourceProtocol,
        productRemoteDataSource: ProductRemoteDataSourceProtocol
    ) {
        self.userRemoteDataSource = userRemoteDataSource
        self.productRemoteDataSource = productRemoteDataSource
    }
    
    func listenUserById(_ id: String) -> AnyPublisher<User, UserError> {
        return userRemoteDataSource.listenUserById(id)
            .map { $0 }
            .mapError { error in
                Logger.log("❌ User Repository Error: \(error)")
                return UserError.internalError
            }
            .flatMap { [weak self] userDTO -> AnyPublisher<User, UserError> in
                guard let self = self else {
                    Logger.log("❌ User Repository Weak Self Error")
                    return Fail(error: UserError.internalError).eraseToAnyPublisher()
                }
                
                Logger.log("✅ User Repository entered - UserDTO: \(userDTO.favorites)")
                
                return self.fetchFavoriteProducts(userDTO.favorites)
                    .map { favorites in
                        Logger.log("✅ Favorites fetched: \(favorites.count) items")
                        return userDTO.toUser(favorites: favorites)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func listenUserFavorites(_ userId: String) -> AnyPublisher<[Product], UserError> {
        return userRemoteDataSource.listenUserById(userId)
            .map { $0 }
            .mapError { error in
                Logger.log("❌ Favorites fetch hatası: \(error)")
                return UserError.internalError
            }
            .flatMap { [weak self] userDTO -> AnyPublisher<[Product], UserError> in
                guard let self = self else {
                    return Fail(error: UserError.internalError).eraseToAnyPublisher()
                }
                
                return self.fetchFavoriteProducts(userDTO.favorites)
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchFavoriteProducts(_ productIds: [String]) -> AnyPublisher<[Product], UserError> {
        guard !productIds.isEmpty else {
            return Just([]).setFailureType(to: UserError.self).eraseToAnyPublisher()
        }
        
        // Her String ID için Product fetch et
        let publishers = productIds.map { productId in
            productRemoteDataSource.getProductById(id: productId)
                .catch { error -> AnyPublisher<Product, UserError> in
                    Logger.log("❌ Failed to fetch product \(productId): \(error)")
                    // Hata durumunda nil döndür, stream'i kesme
                    return Fail(error: UserError.internalError).eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(publishers)
            .collect(productIds.count)
            .map { products in
                Logger.log("\(products)")
                return products.compactMap { $0 }
            }
            .eraseToAnyPublisher()
    }
    
    func updateDefaultAddress(_ id: String, _ addressId: String) -> AnyPublisher<Void, UserError> {
        return userRemoteDataSource.updateDefaultAddress(id: id, addressId: addressId)
            .mapError { error in
                Logger.log(error.localizedDescription)
                return UserError.internalError
            }
            .eraseToAnyPublisher()
    }
    
    
    func addToFavorites(id: String, productId: String) -> AnyPublisher<Void,UserError>{
        return userRemoteDataSource.addToFavorites(id: id, productId: productId)
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
