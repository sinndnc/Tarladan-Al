//
//  Tarladan_AlApp.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI

@main
struct Tarladan_AlApp: App {
    
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var languageManager = LanguageManager()
    
    @UIApplicationDelegateAdaptor(TarladanAlAppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView()
                .preferredColorScheme(themeManager.currentTheme.toColorScheme)
                .environmentObject(themeManager)
                .environmentObject(userViewModel)
                .environmentObject(languageManager)
        }
    }
}
