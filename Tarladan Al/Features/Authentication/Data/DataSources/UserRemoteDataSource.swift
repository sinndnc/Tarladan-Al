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
    func listenUserById(_ id: String) -> AnyPublisher<UserDTO, BaseServiceError<FirebaseManager<UserDTO>>>
    func updateDefaultAddress(id: String, addressId: String) -> AnyPublisher<Void, BaseServiceError<FirebaseManager<UserDTO>>>
    func addToFavorites(id: String, productId: String) -> AnyPublisher<Void, BaseServiceError<FirebaseManager<UserDTO>>>
}

class UserRemoteDataSource: FirebaseManager<UserDTO>, UserRemoteDataSourceProtocol {
    
    private let collection = FirebaseConstants.users
    
    init(db: Firestore) {
        super.init(collectionName: collection)
    }
    
    func listenUserById(_ id: String) -> AnyPublisher<UserDTO, BaseServiceError<FirebaseManager<UserDTO>>>{
        self.listen(id: id)
            .eraseToAnyPublisher()
    }
    
    func updateDefaultAddress(id: String, addressId: String) -> AnyPublisher<Void, BaseServiceError<FirebaseManager<UserDTO>>> {
        return self.get(id: id)
            .flatMap { [weak self] user -> AnyPublisher<Void, BaseServiceError<FirebaseManager<UserDTO>>> in
                guard let self = self else {
                    return Fail(error: ServiceErrorFactory.serviceUnavailable(for: FirebaseManager<UserDTO>.self, operation: ""))
                        .eraseToAnyPublisher()
                }
                
                var mutableUser = user
//                else {
//                    return Fail(error: ServiceErrorFactory.missingDocumentId(for: FirebaseManager<UserDTO>.self, operation: ""))
//                        .eraseToAnyPublisher()
//                }
                
                // Tüm adresleri default olmayan yap
                for i in 0..<mutableUser.addresses.count {
                    mutableUser.addresses[i].isDefault = false
                }
                
                // Belirtilen adresi default yap
                guard let index = mutableUser.addresses.firstIndex(where: { address in
                    return address.id == addressId
                }) else {
                    return Fail(error: ServiceErrorFactory.documentNotFound(for: FirebaseManager<UserDTO>.self, id: "", operation: ""))
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
    
    func addToFavorites(id: String, productId: String) -> AnyPublisher<Void, BaseServiceError<FirebaseManager<UserDTO>>>{
        self.updateArray(id: id, data: [
            FirebaseConstants.favorites: FieldValue.arrayUnion([productId])
        ])
        .eraseToAnyPublisher()
    }
    
}
