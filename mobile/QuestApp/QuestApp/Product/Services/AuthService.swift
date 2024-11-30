//
//  AuthService.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 30.11.2024.
//

import Foundation

protocol IAuthService {
    
    var networkManager  : NetworkManager { get }
    
    func login(model: AuthRequestModel, onSuccess : @escaping (AuthResponseModel)  -> Void, onFailed: @escaping (String) -> Void)
    
}


class AuthService : IAuthService {
    var networkManager: NetworkManager = NetworkManager()
    
    
    func login(model: AuthRequestModel, onSuccess: @escaping (AuthResponseModel) -> Void, onFailed: @escaping (String) -> Void) {
        
        
        networkManager.post(onSuccess: onSuccess, onFailed: onFailed, path:Route.login.value, body: model)
    }
    
   
    
   
    
    
}
