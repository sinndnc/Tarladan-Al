//
//  Tarladan_AlApp.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//

import SwiftUI

@main
struct Tarladan_AlApp: App {
    
    @UIApplicationDelegateAdaptor(TarladanAlAppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView()
                .environmentObject(UserViewModel())
        }
    }
}
