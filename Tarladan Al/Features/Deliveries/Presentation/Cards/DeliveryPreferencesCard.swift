//
//  DeliveryPreferencesCard.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/23/25.
//
import SwiftUI

struct DeliveryPreferencesCard: View {
    var body: some View {
        VStack(spacing: 15) {
            PreferenceRow(
                icon: "location.fill",
                title: "Teslimat Adresi",
                subtitle: "Atatürk Mah. 123. Sk. No:45",
                color: .blue
            )
            PreferenceRow(
                icon: "clock.fill",
                title: "Tercih Edilen Zaman",
                subtitle: "10:00 - 14:00 arası",
                color: .orange
            )
            PreferenceRow(
                icon: "bell.fill",
                title: "Bildirimler",
                subtitle: "SMS ve Push bildirimleri",
                color: .purple
            )
            PreferenceRow(
                icon: "note.text",
                title: "Özel Talimatlar",
                subtitle: "Kapıya bırakın",
                color: .green
            )
        }
        .padding()
    }
}
