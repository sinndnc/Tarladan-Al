//
//  UserViewModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//

import Foundation
import Combine
import FirebaseFirestore

class UserViewModel : ObservableObject{
    
    @Published var user: User?
    @Published var deliveries: [Delivery] = []
    
    @Published var isLoading = false
    @Published var isAuthenticated = false
    
    @Published var cancellables: Set<AnyCancellable> = []
    
    @Injected private var checkUserUseCase: CheckUserUseCaseProtocol
    @Injected private var listenUserUseCase: ListenUserUseCaseProtocol
    @Injected private var updatedefaultAddressUseCase: UpdateDefaultAddressUseCaseProtocol
    
    
    func checkAuthenticationState() {
        isLoading = true
        checkUserUseCase.execute()
            .sink { completion in
                self.isLoading = false
            } receiveValue: { user in
                
                self.user = user
                if let id = user.id {
                    self.loadUser(of: id)
                }
                
                self.isLoading = false
                self.isAuthenticated = true
            }
            .store(in: &cancellables)
    }
    
    func updateDefaultAddress(_ address: Address) {
        guard let userId = user?.id else { return }
        
        updatedefaultAddressUseCase.execute(of: userId, for: address.id ?? "")
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
    
    private func loadUser(of id: String) {
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
    
    
    func saveToFirestore() async {
        let db = Firestore.firestore()
        
        let user = User(
            id: "oIbjdRnaHocigb7HUDhWRg9IFlh2",
            email: "sinandinc53@icloud.com",
            phone: "+905094053438",
            lastName: "Dinç",
            firstName: "Simon",
            profileImageUrl: nil,
            isActive: true,
            isVerified: false,
            phoneVerified: true,
            emailVerified: true,
            createdAt: Calendar.current.date(byAdding: .month, value: -4, to: Date()) ?? Date(),
            updatedAt: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(),
            lastLogin: nil,
            language: "tr",
            currency: "EUR",
            timeZone: "UTC",
            newsletterOptIn: true,
            smsOptIn: true,
            reviews: [],
            addresses: [
                Address(
                    id: "ACA4A038-809D-4229-AA33-AE57EB7FC860",
                    title: "Tatil Evi",
                    fullAddress: "Ankara Mahallesi, 41. Sokak No: 187",
                    city: "Adana",
                    district: "Antalya",
                    isDefault: false
                ),
                Address(
                    id: "A36E6233-2172-4FE7-94DC-5D3AEC20B2C9",
                    title: "Ev",
                    fullAddress: "Kahramanmaraş Mahallesi, 23. Sokak No: 193",
                    city: "Van",
                    district: "Konya",
                    isDefault: true
                )
            ],
            favorites: [], // Uzun olduğu için boş bıraktım, gerekirse eklerim
            paymentMethods: [
                PaymentMethod(
                    id: 6399,
                    type: .bankTransfer,
                    lastFour: "8169",
                    expiryMonth: 5,
                    expiryYear: 2024,
                    cardHolderName: "İrem Keskin",
                    isDefault: true,
                    tokenID: "Si3ktZHe8tJiGPgzuzbFRuWyAFLWaC2k"
                )
            ],
            subscription: nil,
            dietaryPrefs: DietaryPreference(
                organic: true,
                localProduce: false,
                allergies: ["Karides", "Susam", "Ceviz"],
                dislikes: []
            ),
            customerNotes: "Gluten hassasiyeti var, çapraz kontaminasyona dikkat",
            loyaltyPoints: 15,
            referralCode: "YHM623",
            totalOrders: 0,
            totalSpent: 1928.097330202691,
            averageOrder: 47.632901193616675,
            lastOrderDate: nil,
            utmSource: nil,
            utmCampaign: nil,
            referredBy: nil
        )
     
        do {
           try db.collection("users").document(user.id!).setData(from: user)
        } catch {
            print("Error saving user to Firestore: \(error)")
            
        }
        
    }
}
