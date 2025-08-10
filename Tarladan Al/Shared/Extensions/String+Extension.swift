//
//  String+Extension.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/8/25.
//

import Foundation

extension String{
    
    func toDeliveryStatus() -> DeliveryStatus {
        switch self {
        case "in_transit":
            return .inTransit
        case "delivered":
            return .delivered
        case "cancelled":
            return .cancelled
        case "pending":
            return .pending
        case "confirmed":
            return .confirmed
        case "preparing":
            return .preparing
        default :
            return .delivered
        }
    }
}
