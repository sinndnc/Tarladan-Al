//
//  HarvestDateEntryView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/25/25.
//
import SwiftUI

struct HarvestDateEntryView: View {
    var body: some View {
        DetailTemplateView(
            title: "Tarih ve Miktar Girişi",
            icon: "calendar.badge.plus",
            content: "Hasat tarihi ve miktar bilgilerini girebilirsiniz."
        )
    }
}
