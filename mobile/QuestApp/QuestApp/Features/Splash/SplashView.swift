//
//  SplashView.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 21.12.2024.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var router: Router
    @StateObject private var authManager = AuthManager()

    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if authManager.isLoggedIn {
                    MainTabView(authManager: authManager)
                } else {
                    LoginView(authManager: authManager)
                }
            }
            .navigationDestination(for: Router.Destination.self) { destination in
                NavigationViewBuilder(destination: destination, authManager: authManager)
            }
        }
        .onAppear {
            authManager.checkToken()
        }
    }
}
#Preview {
    SplashView()
}
