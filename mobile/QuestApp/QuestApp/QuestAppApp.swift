//
//  QuestAppApp.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 25.11.2024.
//

import SwiftUI
import SwiftData

@main
struct QuestAppApp: App {

    @StateObject var router = Router()
    @StateObject private var authManager = AuthManager()



    var body: some Scene {

        WindowGroup {
            if ProcessInfo.processInfo.arguments.contains("UI-Testing") {
                // UI Test senaryosu
                if ProcessInfo.processInfo.arguments.contains("isLoggedIn_false") {
                    LoginView(authManager: authManager)
                        .environmentObject(authManager)
                        .environmentObject(router)
                        .accessibility(identifier: "loginView")
                } else {
                    SplashView()
                        .environmentObject(authManager)
                        .environmentObject(router)
                }
            } else {
                // Normal uygulama akışı
                SplashView()
                    .environmentObject(authManager)
                    .environmentObject(router)
            }
        }

    }
}
