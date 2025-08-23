//
//  UserViewModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//

import Foundation
import Combine

class UserViewModel : ObservableObject{
    
    @Published var user: User?
    @Published var deliveries: [Delivery] = []
    
    @Published var isLoading = false
    @Published var isAuthenticated = false
    
    @Published var cancellables: Set<AnyCancellable> = []
    
    @Injected private var checkUserUseCase: CheckUserUseCaseProtocol
    @Injected private var listenUserUseCase: ListenUserUseCaseProtocol
    @Injected private var updatedefaultAddressUseCase: UpdateDefaultAddressUseCaseProtocol
    
    private let userID = "02BFE90C-5079-4D24-ACA7-3993B40E6CEB"
    
    func checkAuthenticationState() {
        isLoading = true
        checkUserUseCase.execute()
            .sink { completion in
                self.isLoading = false
            } receiveValue: { user in
                
                self.user = user
                self.listenUser(by: self.userID)
                
                self.isLoading = false
                self.isAuthenticated = true
            }
            .store(in: &cancellables)
    }
    
    func updateDefaultAddress(_ address: Address) {
        guard let userId = user?.id else { return }
        
        updatedefaultAddressUseCase.execute(of: userId, for: address.id.uuidString)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        Logger.log("VIEWMODEL: \(error)")
                    }
                },
                receiveValue: { _ in
                   
                }
            )
            .store(in: &cancellables)
    }
    
    private func listenUser(by id: String) {
        listenUserUseCase.execute(by: id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        Logger.log("")
                    case .failure(let error):
                        Logger.log("VIEW MODEL: Error: \(error)")
                    }
                },
                receiveValue: { [weak self] user in
                    self?.user = user
                    Logger.log("USERVIEWMODEL: \(user)")
                }
            )
            .store(in: &cancellables)
    }
    
}
