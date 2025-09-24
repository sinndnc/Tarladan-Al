//
//  SubMenuRowView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/25/25.
//
import SwiftUI

struct SubMenuRowView: View {
    let subMenuItem: SubMenuItem
    
    var body: some View {
        NavigationLink(value: subMenuItem.id){
            HStack {
                Image(systemName: subMenuItem.icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .frame(width: 25)
                
                Text(subMenuItem.title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
    }
}
