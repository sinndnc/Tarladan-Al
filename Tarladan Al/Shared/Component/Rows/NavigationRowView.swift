//
//  NavigationRow.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//

import SwiftUI

extension NavigationMenuRow where RightContent == EmptyView {
    init(icon: String, title: String, color: Color, destination: AccountDestination) {
        self.icon = icon
        self.title = title
        self.color = color
        self.destination = destination
        self.rightContent = nil
    }
}

struct NavigationMenuRow<RightContent: View>: View {
    let icon: String
    let title: String
    let color: Color
    let destination: AccountDestination
    let rightContent: (() -> RightContent)?
    
    init(icon: String, title: String, color: Color, destination: AccountDestination, rightContent: (() -> RightContent)? = nil) {
        self.icon = icon
        self.title = title
        self.color = color
        self.destination = destination
        self.rightContent = rightContent
    }
    
    var body: some View {
        NavigationLink(value: destination) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 25)
                
                Text(title)
                    .font(.body)
                
                Spacer()
                
                if let rightContent = rightContent {
                    rightContent()
                }
            }
        }
    }
}

