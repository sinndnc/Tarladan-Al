//
//  AuthenticationView.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import SwiftUI

struct AuthenticationView: View {
    
    @EnvironmentObject private var shopViewModel : ShopViewModel
    @EnvironmentObject private var userViewModel : UserViewModel
    @EnvironmentObject private var orderViewModel : OrderViewModel
    @EnvironmentObject private var deliveryViewModel : DeliveryViewModel

    var body: some View {
        ZStack{
            if userViewModel.isLoading || deliveryViewModel.isLoading || shopViewModel.isLoading || orderViewModel.isLoading {
                ProgressView()
            } else if userViewModel.isAuthenticated {
                RootView()
                    .environmentObject(userViewModel)
                
            } else {
                OnBoardView()
            }
        }
        .onAppear {
            userViewModel.checkAuthenticationState()
            
            orderViewModel.setUser(userViewModel.user)
            shopViewModel.setUser(userViewModel.user)
            deliveryViewModel.setUser(userViewModel.user)
        }
        .onChange(of: userViewModel.user) { oldUser, newUser in
            shopViewModel.setUser(newUser)
            orderViewModel.setUser(newUser)
            deliveryViewModel.setUser(newUser)
        }
    }
    
}
