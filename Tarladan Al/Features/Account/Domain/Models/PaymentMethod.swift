//
//  PaymentMethod.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//


struct PaymentMethod: Codable, Identifiable, Hashable {
    let id: Int
    var type: PaymentType
    var lastFour: String
    var expiryMonth: Int
    var expiryYear: Int
    var cardHolderName: String
    var isDefault: Bool
    var tokenID: String // Encrypted token for security
    
    enum PaymentType: String, Codable, CaseIterable {
        case card = "card"
        case paypal = "paypal"
        case bankTransfer = "bank_transfer"
        
        var displayName: String {
            switch self {
            case .card: return "Credit/Debit Card"
            case .paypal: return "PayPal"
            case .bankTransfer: return "Bank Transfer"
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, type, expiryMonth, expiryYear, isDefault
        case lastFour = "last_four"
        case cardHolderName = "card_holder_name"
        case tokenID = "token_id"
    }
}
