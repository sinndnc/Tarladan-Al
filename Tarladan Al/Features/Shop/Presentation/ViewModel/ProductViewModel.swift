//
//  ProductViewModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/15/25.
//

import Foundation
import Combine

final class ProductViewModel : ObservableObject {
    
    @Published var products: [Product] = []
    
    @Injected private var listenProductsUseCase: ListenProductsUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadProducts()
    }
    
    func loadProducts() {
        listenProductsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        Logger.log("✅ VIEW MODEL: Completed successfully")
                    case .failure(let error):
                        Logger.log("❌ VIEW MODEL: Error: \(error)")
                    }
                },
                receiveValue: { [weak self] products in
                    self?.products = products
                }
            )
            .store(in: &cancellables)
    }
    
}
