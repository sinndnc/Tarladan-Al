//
//  RoundedCorner.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/12/25.
//

import SwiftUICore
import UIKit

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
