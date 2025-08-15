//
//  ViewMode.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//


enum ViewMode {
    case grid, list
    
    var icon: String {
        switch self {
        case .grid:
            return "square.grid.2x2"
        case .list:
            return "list.bullet"
        }
    }
}
