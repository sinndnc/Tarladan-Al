//
//  DateFormatter+Extension.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/12/25.
//

import Foundation

extension DateFormatter {
    static let trackingFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter
    }()
    
    static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter
    }()
}
