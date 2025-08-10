//
//  AuthenticationView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI

struct AuthenticationView: View {
    
    @EnvironmentObject private var userViewModel : UserViewModel
    
    var body: some View {
        ZStack{
            Color.blue.edgesIgnoringSafeArea(.all)
            
            if userViewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else if userViewModel.isAuthenticated {
                RootView()
                    .environmentObject(userViewModel)
            } else {
                OnBoardView()
            }
        }
        .onAppear{
            userViewModel.checkAuthenticationState()
        }
    }
    
}
