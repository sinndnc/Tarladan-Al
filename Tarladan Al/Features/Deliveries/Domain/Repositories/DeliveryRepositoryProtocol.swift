//
//  DeliveryRepositoryProtocol.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/6/25.
//

import Foundation
import CoreLocation
import Combine

protocol DeliveryRepositoryProtocol {
    func listenDeliveries() -> AnyPublisher<[Delivery], DeliveryError>
    func getDeliveryById(_ id: String) -> AnyPublisher<Delivery, DeliveryError>
    func createDelivery(_ delivery: Delivery) async throws -> Delivery
    func updateDeliveryStatus(_ id: String, status: DeliveryStatus) async throws
    func updateDeliveryLocation(_ id: String, location: CLLocationCoordinate2D) async throws
    func getDeliveryHistory(customerId: String) async throws -> [Delivery]
    func cancelDelivery(_ id: String) async throws
}
