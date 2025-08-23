//
//  DeliveriesViewModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/1/25.
//

import Foundation
import Combine
import FirebaseFirestore

final class DeliveryViewModel: ObservableObject {
    
    @Published var user: User? = nil
    @Published var deliveries: [Delivery] = []
    @Published var filteredDeliveries: [Delivery] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    @Injected private var createDeliveriesUseCase: CreateDeliveryUseCaseProtocol
    @Injected private var listenDeliveriesUseCase: ListenDeliveriesUseCaseProtocol
    @Injected private var updateDeliveryStatusUseCase: UpdateDeliveryStatusUseCaseProtocol
    
    var currentDeliveries : [Delivery] {
        deliveries.filter{ $0.status != .delivered && $0.status != .cancelled }
    }
    
    var currentDelivery: Delivery? {
        deliveries.filter{ $0.status != .delivered && $0.status != .cancelled }
            .first
    }
    
    init(){
        listenDeliveries(by: "")
    }
    
    func listenDeliveries(by id: String) {
        listenDeliveriesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    
                },
                receiveValue: { [weak self] deliveries in
                    self?.deliveries = deliveries
                }
            )
            .store(in: &cancellables)
    }
}

extension DeliveryViewModel{
    
    func createDeliveries(){
        let db = Firestore.firestore()
        let deliveries = createSampleDeliveries()
          
        for delivery in deliveries {
            do {
                // Convert delivery to dictionary for Firebase
                let deliveryData = try Firestore.Encoder().encode(delivery)
                
                // Upload to Firebase
                db.collection("deliveries").document(delivery.id ?? "").setData(deliveryData) { error in
                    if let error = error {
                        print("Error uploading delivery \(delivery.id): \(error.localizedDescription)")
                    } else {
                        print("Successfully uploaded delivery: \(delivery.orderNumber)")
                    }
                }
            } catch {
                print("Error encoding delivery \(delivery.id): \(error.localizedDescription)")
            }
        }
    }
    
    func createSampleDeliveries() -> [DeliveryDTO] {
        let deliveries = [
            // Delivery 1 - Completed
            DeliveryDTO(
                orderNumber: "ORD-2025-001",
                customerId: "customer_123",
                customerName: "Ahmet Yılmaz",
                customerEmail: "ahmet.yilmaz@email.com",
                customerPhone: "+90 532 123 45 67",
                deliveryAddress: DeliveryAddress(
                    street: "İstanbul Caddesi No:67",
                    city: "Osmangazi",
                    district: "Bursa",
                    postalCode: "16040",
                    country: "Türkiye",
                    latitude: 34.535,
                    longitude: 25.6456,
                    instructions: "instructions"
                ),
                items: [
                    DeliveryItemDTO(
                        id: "item_001",
                        productName: "Organik Domates",
                        productId: "prod_tomato_001",
                        quantity: 2.5,
                        unit: "kg",
                        pricePerUnit: 12.0,
                        totalPrice: 30.0,
                        isTemperatureSensitive: true,
                        requiredTemperature: 4.0
                    ),
                    DeliveryItemDTO(
                        id: "item_002",
                        productName: "Tam Buğday Ekmek",
                        productId: "prod_bread_001",
                        quantity: 3.0,
                        unit: "adet",
                        pricePerUnit: 8.5,
                        totalPrice: 25.5,
                        isTemperatureSensitive: false,
                        requiredTemperature: nil
                    )
                ],
                status: "completed",
                createdAt: Timestamp(date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()),
                scheduledDeliveryDate: Timestamp(date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()),
                actualDeliveryDate: Timestamp(date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()),
                totalAmount: 55.5,
                deliveryFee: 8.0,
                specialInstructions: "Kapı zilini çalmayın, WhatsApp'tan mesaj atın",
                driverNotes: "Teslim edildi. Müşteri memnun.",
                currentLatitude: 40.1826,
                currentLongitude: 29.0670
            ),
            
            // Delivery 2 - In Transit
            DeliveryDTO(
                orderNumber: "ORD-2025-002",
                customerId: "customer_456",
                customerName: "Fatma Kaya",
                customerEmail: "fatma.kaya@email.com",
                customerPhone: "+90 535 987 65 43",
                deliveryAddress:
                    DeliveryAddress(
                        street: "Fevzi Çakmak Caddesi No:42/A",
                        city: "Nilüfer",
                        district: "Bursa",
                        postalCode: "16120",
                        country: "Türkiye",
                        latitude: 34.535,
                        longitude: 25.6456,
                        instructions: "instructions"
                    ),
                items: [
                    DeliveryItemDTO(
                        id: "item_003",
                        productName: "Süt",
                        productId: "prod_milk_001",
                        quantity: 2.0,
                        unit: "litre",
                        pricePerUnit: 15.0,
                        totalPrice: 30.0,
                        isTemperatureSensitive: true,
                        requiredTemperature: 2.0
                    ),
                    DeliveryItemDTO(
                        id: "item_004",
                        productName: "Beyaz Peynir",
                        productId: "prod_cheese_001",
                        quantity: 0.5,
                        unit: "kg",
                        pricePerUnit: 45.0,
                        totalPrice: 22.5,
                        isTemperatureSensitive: true,
                        requiredTemperature: 4.0
                    ),
                    DeliveryItemDTO(
                        id: "item_005",
                        productName: "Makarna",
                        productId: "prod_pasta_001",
                        quantity: 4.0,
                        unit: "paket",
                        pricePerUnit: 6.0,
                        totalPrice: 24.0,
                        isTemperatureSensitive: false,
                        requiredTemperature: nil
                    )
                ],
                status: "in_transit",
                createdAt: Timestamp(date: Calendar.current.date(byAdding: .hour, value: -6, to: Date()) ?? Date()),
                scheduledDeliveryDate: Timestamp(date: Calendar.current.date(byAdding: .hour, value: 2, to: Date()) ?? Date()),
                actualDeliveryDate: nil,
                totalAmount: 76.5,
                deliveryFee: 10.0,
                specialInstructions: "Apartman girişi şifreli, kod: 1234",
                driverNotes: "Yolda, tahmini 30 dakika kaldı",
                currentLatitude: 40.2033,
                currentLongitude: 28.9875
            ),
            
            // Delivery 3 - Pending
            DeliveryDTO(
                orderNumber: "ORD-2025-003",
                customerId: "customer_789",
                customerName: "Mehmet Özkan",
                customerEmail: "mehmet.ozkan@email.com",
                customerPhone: "+90 542 456 78 90",
                deliveryAddress:
                    DeliveryAddress(
                        street: "Cumhuriyet Mahallesi, Zafer Sokak No:8",
                        city: "Yıldırım",
                        district: "Bursa",
                        postalCode: "16350",
                        country: "Türkiye",
                        latitude: 34.535,
                        longitude: 25.6456,
                        instructions: "instructions"
                    ),
                items: [
                    DeliveryItemDTO(
                        id: "item_006",
                        productName: "Tavuk Göğsü",
                        productId: "prod_chicken_001",
                        quantity: 1.2,
                        unit: "kg",
                        pricePerUnit: 35.0,
                        totalPrice: 42.0,
                        isTemperatureSensitive: true,
                        requiredTemperature: -2.0
                    ),
                    DeliveryItemDTO(
                        id: "item_007",
                        productName: "Salatalık",
                        productId: "prod_cucumber_001",
                        quantity: 1.5,
                        unit: "kg",
                        pricePerUnit: 8.0,
                        totalPrice: 12.0,
                        isTemperatureSensitive: false,
                        requiredTemperature: nil
                    ),
                    DeliveryItemDTO(
                        id: "item_008",
                        productName: "Dondurma",
                        productId: "prod_icecream_001",
                        quantity: 2.0,
                        unit: "adet",
                        pricePerUnit: 18.0,
                        totalPrice: 36.0,
                        isTemperatureSensitive: true,
                        requiredTemperature: -18.0
                    )
                ],
                status: "pending",
                createdAt: Timestamp(date: Calendar.current.date(byAdding: .minute, value: -30, to: Date()) ?? Date()),
                scheduledDeliveryDate: Timestamp(date: Calendar.current.date(byAdding: .hour, value: 4, to: Date()) ?? Date()),
                actualDeliveryDate: nil,
                totalAmount: 90.0,
                deliveryFee: 12.0,
                specialInstructions: nil,
                driverNotes: nil,
                currentLatitude: nil,
                currentLongitude: nil
            ),
            
            // Delivery 4 - Cancelled
            DeliveryDTO(
                orderNumber: "ORD-2025-004",
                customerId: "customer_321",
                customerName: "Ayşe Demir",
                customerEmail: "ayse.demir@email.com",
                customerPhone: "+90 533 222 33 44",
                deliveryAddress: DeliveryAddress(
                    street: "İstanbul Caddesi No:67",
                    city: "Osmangazi",
                    district: "Bursa",
                    postalCode: "16040",
                    country: "Türkiye",
                    latitude: 34.535,
                    longitude: 25.6456,
                    instructions: "instructions"
                ),
                items: [
                    DeliveryItemDTO(
                        id: "item_009",
                        productName: "Elma",
                        productId: "prod_apple_001",
                        quantity: 3.0,
                        unit: "kg",
                        pricePerUnit: 10.0,
                        totalPrice: 30.0,
                        isTemperatureSensitive: false,
                        requiredTemperature: nil
                    ),
                    DeliveryItemDTO(
                        id: "item_010",
                        productName: "Portakal",
                        productId: "prod_orange_001",
                        quantity: 2.0,
                        unit: "kg",
                        pricePerUnit: 12.0,
                        totalPrice: 24.0,
                        isTemperatureSensitive: false,
                        requiredTemperature: nil
                    )
                ],
                status: "cancelled",
                createdAt: Timestamp(date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()),
                scheduledDeliveryDate: Timestamp(date: Date()),
                actualDeliveryDate: nil,
                totalAmount: 54.0,
                deliveryFee: 8.0,
                specialInstructions: "Evde kimse yok, iptal edilsin",
                driverNotes: "Müşteri talebi üzerine iptal edildi",
                currentLatitude: nil,
                currentLongitude: nil
            ),
            
            // Delivery 5 - Out for Delivery
            DeliveryDTO(
                orderNumber: "ORD-2025-005",
                customerId: "customer_654",
                customerName: "Can Arslan",
                customerEmail: "can.arslan@email.com",
                customerPhone: "+90 534 111 22 33",
                deliveryAddress: DeliveryAddress(
                    street: "İstanbul Caddesi No:67",
                    city: "Osmangazi",
                    district: "Bursa",
                    postalCode: "16040",
                    country: "Türkiye",
                    latitude: 34.535,
                    longitude: 25.6456,
                    instructions: "instructions"
                ),
                items: [
                    DeliveryItemDTO(
                        id: "item_011",
                        productName: "Balık (Levrek)",
                        productId: "prod_fish_001",
                        quantity: 0.8,
                        unit: "kg",
                        pricePerUnit: 55.0,
                        totalPrice: 44.0,
                        isTemperatureSensitive: true,
                        requiredTemperature: 0.0
                    ),
                    DeliveryItemDTO(
                        id: "item_012",
                        productName: "Limon",
                        productId: "prod_lemon_001",
                        quantity: 1.0,
                        unit: "kg",
                        pricePerUnit: 14.0,
                        totalPrice: 14.0,
                        isTemperatureSensitive: false,
                        requiredTemperature: nil
                    ),
                    DeliveryItemDTO(
                        id: "item_013",
                        productName: "Maydanoz",
                        productId: "prod_parsley_001",
                        quantity: 0.5,
                        unit: "demet",
                        pricePerUnit: 4.0,
                        totalPrice: 2.0,
                        isTemperatureSensitive: true,
                        requiredTemperature: 4.0
                    )
                ],
                status: "out_for_delivery",
                createdAt: Timestamp(date: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date()),
                scheduledDeliveryDate: Timestamp(date: Calendar.current.date(byAdding: .minute, value: 45, to: Date()) ?? Date()),
                actualDeliveryDate: nil,
                totalAmount: 60.0,
                deliveryFee: 15.0,
                specialInstructions: "Taze olsun, buzla taşıyın",
                driverNotes: "Soğuk zincir korunuyor, müşteriye yaklaşıyorum",
                currentLatitude: 40.3667,
                currentLongitude: 28.8833
            )
        ]
        
        return deliveries
    }
}
