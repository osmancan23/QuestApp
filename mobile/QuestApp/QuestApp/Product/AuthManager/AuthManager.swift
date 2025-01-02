//
//  AuthManager.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 21.12.2024.
//

import Foundation
import SwiftUI

class AuthManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUsername: String = "user"
    
    func checkToken() {
        if let _ = KeychainHelper.shared.read(for: "authToken") {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
    
    func setUsername(_ username: String) {
        currentUsername = username
    }
    
    func logout() {
        KeychainHelper.shared.delete(for: "authToken")
        isLoggedIn = false
        currentUsername = "user"
    }
    
    // NetworkManager'dan 401 hatası alındığında çağrılacak method
        func handleUnauthorized() {
            DispatchQueue.main.async { [weak self] in
                self?.logout()
            }
        }
}
