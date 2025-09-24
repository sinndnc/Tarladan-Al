//
//  DeliveriesRepository.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/6/25.
//

import Foundation
import CoreLocation
import FirebaseFirestore
import Combine

final class DeliveryRepository: DeliveryRepositoryProtocol {
    private let remoteDataSource: DeliveryRemoteDataSourceProtocol
//    private let localDataSource: DeliveryLocalDataSource
    
    init(
        remoteDataSource: DeliveryRemoteDataSourceProtocol,
//        localDataSource: DeliveryLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
//        self.localDataSource = localDataSource
    }
    
    func listenDeliveries(for id: String) -> AnyPublisher<[Delivery], DeliveryError> {
        return remoteDataSource.getDeliveries(for: id)
            .map { dtos in
                dtos.compactMap { self.mapToDelivery($0) }
            }
            .eraseToAnyPublisher()
    }
    
    func getDeliveryById(_ id: String) -> AnyPublisher<Delivery, DeliveryError>  {
        return remoteDataSource.getDeliveryById(id)
            .compactMap { dto in
                self.mapToDelivery(dto)
            }
            .mapError { _ in DeliveryError.invalidStatusTransition }
            .eraseToAnyPublisher()
    }
    
    func createDelivery(_ delivery: Delivery) async throws -> Delivery {
        let dto = mapToDTO(delivery)
        remoteDataSource.createDelivery(dto)
        return delivery
    }
    
    func updateDeliveryStatus(_ id: String, status: DeliveryStatus)  {
        remoteDataSource.updateDeliveryStatus(id, status: status.rawValue)
    }
    
    func updateDeliveryLocation(_ id: String, location: CLLocationCoordinate2D) async throws {
        remoteDataSource.updateDeliveryLocation(id, latitude: location.latitude, longitude: location.longitude)
    }
    
    func getDeliveryHistory(customerId: String) async throws -> [Delivery] {
        // Implementation for getting customer delivery history
        return []
    }
    
    func cancelDelivery(_ id: String) async throws {
       updateDeliveryStatus(id, status: .cancelled)
    }
    
    // MARK: - Mapping functions
    private func mapToDelivery(_ dto: DeliveryDTO) -> Delivery {
        return dto.toDelivery()
    }
    
    private func mapToDTO(_ delivery: Delivery) -> DeliveryDTO {
        return delivery.toDeliveryDTO()
    }
}
