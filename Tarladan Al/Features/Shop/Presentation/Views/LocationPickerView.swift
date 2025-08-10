//
//  LocationPickerView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/10/25.
//

import SwiftUI

struct LocationPickerView: View {
    
    var body: some View {
        ZStack{
            Text("location:")
        }
        .background(Color(.systemGray6))
        .presentationDetents([.fraction(0.2)])
    }
    
}

#Preview {
    LocationPickerView()
}
