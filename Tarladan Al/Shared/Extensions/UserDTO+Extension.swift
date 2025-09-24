//
//  UserDTO+Extension.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/22/25.
//

import Foundation

extension UserDTO {
    
    func toUser(favorites: [Product]) -> User {
        return User(
            id: id,
            email: email,
            phone: phone,
            lastName: lastName,
            firstName: firstName,
            accountType: accountType,
            profileImageUrl: profileImageUrl,
            isActive: isActive,
            isVerified: isVerified,
            phoneVerified: phoneVerified,
            emailVerified: emailVerified,
            createdAt: createdAt,
            updatedAt: updatedAt,
            language: language,
            currency: currency,
            timeZone: timeZone,
            newsletterOptIn: newsletterOptIn,
            smsOptIn: smsOptIn,
            reviews: reviews,
            addresses: addresses,
            favorites: favorites,
            paymentMethods: paymentMethods,
            dietaryPrefs: dietaryPrefs,
            customerNotes: customerNotes,
            loyaltyPoints: loyaltyPoints,
            referralCode: referralCode,
            totalOrders: totalOrders,
            totalSpent: totalSpent,
            averageOrder: averageOrder
        )
    }
}
