//
//  LoginViewModel.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 12.12.2024.
//

import Foundation
import SwiftUI
import Alamofire
final class LoginViewModel : ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    
    let authService: IAuthService = AuthService()

    
    func login()  {
        print(username)
        print(password)
        authService.login(model: AuthRequestModel(userName: username, password: password)) { response in
            if let tokenData = response?.accessToken.data(using: .utf8) {
                KeychainHelper.shared.save(tokenData, for: "authToken")
            }
            print("Gelen Token")
            print(response?.accessToken)
           
            
        } onFailed: { error in
            print(error)
        }
        
        
    }
    
   
}
