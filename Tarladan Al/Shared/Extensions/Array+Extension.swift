//
//  Array+Extension.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/13/25.
//

import Foundation

extension Array where Element == Address {
    var sortedByDefault: [Address] {
        return self.sorted { $0.isDefault && !$1.isDefault }
    }
}
