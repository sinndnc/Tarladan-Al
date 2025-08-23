//
//  LanguageSelectionView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/11/25.
//
import SwiftUI

struct LanguagesView: View {
    
    @EnvironmentObject private var languageManager: LanguageManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section("Choose Language") {
                ForEach(Language.allCases, id: \.self) { language in
                    Button{
                        languageManager.setLanguage(language)
                        dismiss()
                    }label: {
                        HStack {
                            Text(language.displayName)
                            Spacer()
                            if language == languageManager.currentLanguage {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .tint(.primary)
                }
            }
        }
        .navigationTitle("Languages")
        .navigationBarTitleDisplayMode(.inline)
    }
}
