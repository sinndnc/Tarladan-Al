//
//  Date+Extension.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//

import Foundation

extension Date {
    var iso8601String: String {
        ISO8601DateFormatter().string(from: self)
    }
}
