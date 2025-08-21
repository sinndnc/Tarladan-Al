//
//  Address+Extension.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/21/25.
//

import Foundation

extension Address {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["id"] = self.id.uuidString
        dict["city"] = self.city
        dict["title"] = self.title
        dict["district"] = self.district
        dict["fullAddress"] = self.fullAddress
        dict["isDefault"] = self.isDefault
        
        return dict
    }
}
