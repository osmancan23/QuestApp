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
            SplashView().environmentObject(router)
       
        }

    }
}
