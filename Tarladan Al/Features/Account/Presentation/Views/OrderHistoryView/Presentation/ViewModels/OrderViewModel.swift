//
//  OrderViewModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/2/25.
//

import Foundation
import Combine

final class OrderViewModel: ObservableObject {
    
    @Published var orders: [Order] = []
    @Published var isLoading : Bool = false
    
    private var currentUserId: String?
    private var cancellables: Set<AnyCancellable> = []
    
    @Injected private var listenOrdersOfUserUseCase: ListenOrdersOfUserUseCaseProtocol
    
    func setUser(_ user: User?) {
        guard let user = user, let userId = user.id else {
            // User yoksa orders'ı temizle
            self.orders = []
            self.currentUserId = nil
            self.cancellables.removeAll()
            return
        }
        
        guard currentUserId != userId else { return }
        
        self.currentUserId = userId
        self.loadOrders(of: userId)
    }
    
    private func loadOrders(of userId: String) {
        isLoading = true
        cancellables.removeAll()
        listenOrdersOfUserUseCase.execute(of: userId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    Logger.log("finish")
                case .failure(let error):
                    self.orders = []
                    self.isLoading = false
                    Logger.log("Error loading orders: \(error)")
                    // Hata durumunda orders'ı temizleyebilirsiniz
                }
            } receiveValue: { [weak self] orders in
                self?.orders = orders
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
}
