//
//  LoginViewModel.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 12.12.2024.
//

import Foundation

final class LoginViewModel : ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    
    let authService: IAuthService = AuthService()
    
    
    func login()  {
        print(username)
        print(password)
        authService.login(model: AuthRequestModel(userName: username, password: password)) { response in
            print(response)
            print(response?.accessToken)
        } onFailed: { error in
            print(error)
        }

    }
}
