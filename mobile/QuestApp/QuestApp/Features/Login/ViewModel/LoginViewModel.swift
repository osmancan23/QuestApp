//
//  LoginViewModel.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 12.12.2024.
//

import Foundation
import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false

    private let authService: IAuthService
    private let authManager: AuthManager

    init(authService: IAuthService = AuthService(), authManager: AuthManager = AuthManager()) {
        self.authService = authService
        self.authManager = authManager
    }

    func login() {
        // Boş alan kontrolü
        if username.isEmpty || password.isEmpty {
            isError = true
            errorMessage = "Kullanıcı adı ve şifre boş bırakılamaz"
            return
        }

        isLoading = true
        let model = AuthRequestModel(userName: username, password: password)

        authService.login(model: model) { [weak self] response in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let token = response?.accessToken {
                    let cleanToken = token.replacingOccurrences(of: "Bearer ", with: "")
                    if let tokenData = cleanToken.data(using: .utf8) {
                        KeychainHelper.shared.save(tokenData, for: "authToken")
                        self?.isLoggedIn = true
                        self?.authManager.setUsername(self?.username ?? "")
                    } else {
                        self?.isError = true
                        self?.errorMessage = "Oturum açma işlemi başarısız oldu. Lütfen tekrar deneyin."
                    }
                } else { 
                    self?.isError = true

                    self?.errorMessage = "Kullanıcı adı veya şifre hatalı"
                }
            }
        } onFailed: { [weak self] error in
            self?.isError = true

            DispatchQueue.main.async {
                self?.isLoading = false
                if error.contains("401") || error.contains("Kullanıcı adı veya şifre hatalı") {
                    self?.errorMessage = "Kullanıcı adı veya şifre hatalı"
                } else if error.contains("timeout") || error.contains("connection") {
                    self?.errorMessage = "Bağlantı hatası. Lütfen internet bağlantınızı kontrol edin."
                } else {
                    self?.errorMessage = "Bir hata oluştu. Lütfen tekrar deneyin."
                }
            }
        }
    }
}
