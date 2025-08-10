//
//  TarladanAlAppDelegate.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//

import Foundation
import UIKit
import FirebaseCore

final class TarladanAlAppDelegate : NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        setupDependencyContainer()
        
        return true
    }
}

extension TarladanAlAppDelegate  {
    
    func setupDependencyContainer() {
        FirebaseAppConfiguration.shared.configure()
        AppDIConfiguration.configure()
        
    }
    
}
