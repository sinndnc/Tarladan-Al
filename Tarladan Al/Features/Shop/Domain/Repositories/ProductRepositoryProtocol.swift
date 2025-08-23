//
//  ProductRepositoryProtocol.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//
import Combine

protocol ProductRepositoryProtocol {
    
    func listenProducts() -> AnyPublisher<[Product], ProductError>
    func getProductById(id: String) -> AnyPublisher<Product, ProductError>
    
}
