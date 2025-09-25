//
//  SubMenuRowView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/25/25.
//
import SwiftUI

struct MenuRowView: View {
    let menuItem: MenuItem
    
    var body: some View {
        NavigationLink(value: menuItem.action){
            HStack {
                Image(systemName: menuItem.icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .frame(width: 25)
                
                Text(menuItem.title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.vertical, 4)
        }
    }
}
