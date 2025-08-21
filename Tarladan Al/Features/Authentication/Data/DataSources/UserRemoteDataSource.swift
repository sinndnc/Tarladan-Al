//
//  UserRemoteDataSource.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//

import Foundation
import Combine
import FirebaseFirestore

protocol UserRemoteDataSourceProtocol{
    func listenUserById(_ id: String) -> AnyPublisher<User, BaseServiceError<FirebaseManager<User>>>
    func updateDefaultAddress(id: String, addressId: String) -> AnyPublisher<Void, BaseServiceError<FirebaseManager<User>>>
    func addToFavorites(id: String, data: [String: Any]) -> AnyPublisher<Void, BaseServiceError<FirebaseManager<User>>>
}

class UserRemoteDataSource: FirebaseManager<User>, UserRemoteDataSourceProtocol {
    
    private let collection = FirebaseConstants.users
    
    init(db: Firestore) {
        super.init(collectionName: collection)
    }
    
    func listenUserById(_ id: String) -> AnyPublisher<User, BaseServiceError<FirebaseManager<User>>>{
        self.listen(id: id)
            .eraseToAnyPublisher()
    }
    
    func updateDefaultAddress(id: String, addressId: String) -> AnyPublisher<Void, BaseServiceError<FirebaseManager<User>>> {
        return self.get(id: id)
            .flatMap { [weak self] user -> AnyPublisher<Void, BaseServiceError<FirebaseManager<User>>> in
                guard let self = self else {
                    return Fail(error: ServiceErrorFactory.serviceUnavailable(for: FirebaseManager<User>.self, operation: ""))
                        .eraseToAnyPublisher()
                }
                
                guard var mutableUser = user else {
                    return Fail(error: ServiceErrorFactory.missingDocumentId(for: FirebaseManager<User>.self, operation: ""))
                        .eraseToAnyPublisher()
                }
                
                // Tüm adresleri default olmayan yap
                for i in 0..<mutableUser.addresses.count {
                    mutableUser.addresses[i].isDefault = false
                }
                
                // Belirtilen adresi default yap
                guard let index = mutableUser.addresses.firstIndex(where: { address in
                    return address.id.uuidString == addressId
                }) else {
                    return Fail(error: ServiceErrorFactory.documentNotFound(for: FirebaseManager<User>.self, id: "", operation: ""))
                        .eraseToAnyPublisher()
                }
                
                mutableUser.addresses[index].isDefault = true
                
                // Güncelleme işlemini yap
                return self.update(id: id, data: [
                    "addresses": mutableUser.addresses.map{
                        $0.toDictionary()
                    }
                ])
            }
            .eraseToAnyPublisher()
    }
    
    func addToFavorites(id: String, data: [String: Any]) -> AnyPublisher<Void, BaseServiceError<FirebaseManager<User>>>{
        self.updateArray(id: id, data: [
            FirebaseConstants.favorites: [data]
        ])
        .eraseToAnyPublisher()
    }
    
}
