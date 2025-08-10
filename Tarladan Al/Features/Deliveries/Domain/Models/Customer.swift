//
//  Customer.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/6/25.
//

import Foundation


struct Customer: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let email: String
    let phone: String
    let address: DeliveryAddress
    let isVipCustomer: Bool
    let totalOrders: Int
    let registrationDate: Date
    
    init(id: String = UUID().uuidString,
         name: String,
         email: String,
         phone: String,
         address: DeliveryAddress,
         isVipCustomer: Bool = false,
         totalOrders: Int = 0,
         registrationDate: Date = Date()) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
        self.isVipCustomer = isVipCustomer
        self.totalOrders = totalOrders
        self.registrationDate = registrationDate
    }
}
