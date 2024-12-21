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

    init() {
        checkToken()
    }

    func checkToken() {
        if let tokenData = KeychainHelper.shared.read(for: "authToken"),
           let token = String(data: tokenData, encoding: .utf8) {
            // Token'ı doğrulama (örneğin: süresi geçmiş mi kontrol et)
            isLoggedIn = !token.isEmpty // Token varsa giriş yapılmış kabul edilir
        } else {
            isLoggedIn = false
        }
        
        print("Token var mı? \(isLoggedIn)")
    }

    func logout() {
        KeychainHelper.shared.delete(for: "authToken")
        isLoggedIn = false
    }
}
