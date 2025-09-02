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
        
        // Aynı user ise tekrar load etme
        guard currentUserId != userId else { return }
        
        Logger.log("\(userId)")
        self.currentUserId = userId
        self.loadOrders(of: userId)
    }
    
    private func loadOrders(of userId: String) {
        // Önceki subscription'ları iptal et
        cancellables.removeAll()
        
        listenOrdersOfUserUseCase.execute(of: userId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    Logger.log("finish")
                case .failure(let error):
                    Logger.log("Error loading orders: \(error)")
                    // Hata durumunda orders'ı temizleyebilirsiniz
                    // self.orders = []
                }
            } receiveValue: { [weak self] orders in
                Logger.log("ORDERS:\(orders)")
                self?.orders = orders
            }
            .store(in: &cancellables)
    }
    
}
