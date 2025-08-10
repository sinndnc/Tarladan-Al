//
//  DeliveryRemoteDataSource.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/6/25.
//

import FirebaseFirestore
import Combine

protocol DeliveryRemoteDataSourceProtocol{
    func getDeliveries() -> AnyPublisher<[DeliveryDTO],DeliveryError>
    func getDeliveryById(_ id: String) ->  AnyPublisher<DeliveryDTO,DeliveryError>
    func createDelivery(_ delivery: DeliveryDTO)
    func updateDeliveryStatus(_ id: String, status: String)
    func updateDeliveryLocation(_ id: String, latitude: Double, longitude: Double)
    func listenToDeliveryUpdates(completion: @escaping ([DeliveryDTO]) -> Void) -> ListenerRegistration
}

final class DeliveryRemoteDataSource : DeliveryRemoteDataSourceProtocol {
    private let firestore : Firestore
    private let collection = FirebaseConstants.deliveries
    
    init(firestore: Firestore) {
        self.firestore = firestore
    }
    
    func getDeliveries() -> AnyPublisher<[DeliveryDTO],DeliveryError>{
        return Future<[DeliveryDTO], DeliveryError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.unkownError))
                return
            }
            
            self.firestore.collection(collection)
//                .order(by: "created_at", descending: true)
                .getDocuments { snapshot, error in
                    if let error = error {
                        promise(.failure(.firebaseError(error.localizedDescription)))
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        promise(.failure(.deliveryNotFound))
                        return
                    }
                    
                    let deliveries = documents.compactMap { document -> DeliveryDTO? in
                        try? document.data(as: DeliveryDTO.self)
                    }
                    
                    promise(.success(deliveries))
                }
        }
        .eraseToAnyPublisher()
    }
    
    func getDeliveryById(_ id: String) -> AnyPublisher<DeliveryDTO,DeliveryError> {
        return Future<DeliveryDTO, DeliveryError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.unkownError))
                return
            }
            
            self.firestore.collection(collection)
                .document(id)
                .getDocument { snapshot, error in
                    if let error = error {
                        promise(.failure(.firebaseError(error.localizedDescription)))
                        return
                    }
                    
                    guard let document = snapshot, document.exists,
                          let package = try? document.data(as: DeliveryDTO.self) else {
                        promise(.failure(.deliveryNotFound))
                        return
                    }
                    
                    promise(.success(package))
                }
        }
        .eraseToAnyPublisher()
    }
    
    func createDelivery(_ delivery: DeliveryDTO)  {
//        try await firestore.collection(collection).document(delivery.id).setData(from: delivery)
    }
    
    func updateDeliveryStatus(_ id: String, status: String) {
//        try await firestore.collection(collection).document(id).updateData([
//            "status": status,
//            "updatedAt": Timestamp()
//        ])
    }
    
    func updateDeliveryLocation(_ id: String, latitude: Double, longitude: Double) {
//        try await firestore.collection(collection).document(id).updateData([
//            "currentLatitude": latitude,
//            "currentLongitude": longitude,
//            "updatedAt": Timestamp()
//        ])
    }
    
    func listenToDeliveryUpdates(completion: @escaping ([DeliveryDTO]) -> Void) -> ListenerRegistration {
        return firestore.collection(collection)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                let deliveries = documents.compactMap { document in
                    try? document.data(as: DeliveryDTO.self)
                }
                completion(deliveries)
            }
    }
}
