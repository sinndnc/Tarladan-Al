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
   
}
