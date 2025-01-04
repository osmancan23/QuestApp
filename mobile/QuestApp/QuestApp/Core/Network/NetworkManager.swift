//
//  NetworkManager.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 28.11.2024.
//

import Foundation
import Alamofire

struct ErrorResponse: Codable {
    let status: Int
    let message: String
    let timestamp: Int64
}

final class NetworkManager {
    static let shared = NetworkManager()
    static let baseURL = "http://localhost:8080"
    
    private var authManager: AuthManager?
    private var router: Router?
    
    var token: String? {
        get {
            if let tokenData = KeychainHelper.shared.read(for: "authToken"),
               let token = String(data: tokenData, encoding: .utf8) {
                return token
            }
            return nil
        }
        set {
            if let newValue = newValue,
               let tokenData = newValue.data(using: .utf8) {
                KeychainHelper.shared.save(tokenData, for: "authToken")
            } else {
                KeychainHelper.shared.delete(for: "authToken")
            }
        }
    }
    
    private init() {}
    
    func configure(authManager: AuthManager, router: Router) {
        self.authManager = authManager
        self.router = router
    }
    
    func request<T: Codable>(path: String,
                            method: HTTPMethod,
                            model: Encodable? = nil,
                            shouldParse: Bool = true,
                            completion: @escaping (T?) -> Void,
                            onFailed: @escaping (String) -> Void) {
        let urlString = "\(NetworkManager.baseURL)\(path)"
        guard let url = URL(string: urlString) else {
            onFailed("URL oluşturulamadı")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Her zaman Content-Type header'ı ekle
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Token varsa ekle
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("Token eklendi: Bearer \(token)") // Debug için
        } else {
            print("Token bulunamadı") // Debug için
        }
        
        if let model = model {
            do {
                let jsonData = try JSONEncoder().encode(model)
                request.httpBody = jsonData
            } catch {
                onFailed("Model JSON'a dönüştürülemedi")
                return
            }
        }
        
        print("Request URL: \(urlString)") // Debug için
        print("Request Method: \(method.rawValue)") // Debug için
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])") // Debug için
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                onFailed(error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                onFailed("Geçersiz sunucu yanıtı")
                return
            }
            
            print("Response Status Code: \(httpResponse.statusCode)") // Debug için
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)") // Debug için
            }
            
            if httpResponse.statusCode == 401 {
                DispatchQueue.main.async {
                    self.authManager?.handleUnauthorized()
                    self.router?.navigate(to: .login)
                }
                onFailed("Oturum süreniz doldu. Lütfen tekrar giriş yapın.")
                return
            }
            
            if httpResponse.statusCode == 200 {
                if shouldParse {
                    if let data = data {
                        do {
                            let decodedData = try JSONDecoder().decode(T.self, from: data)
                            completion(decodedData)
                        } catch {
                            print("Decode Error: \(error)") // Debug için
                            onFailed("Veri işlenemedi: \(error.localizedDescription)")
                        }
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            } else {
                // Hata mesajını parse et
                if let data = data {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        onFailed(errorResponse.message)
                    } catch {
                        // JSON parse edilemezse status code'a göre genel hata mesajı
                        switch httpResponse.statusCode {
                        case 401:
                            onFailed("Kullanıcı adı veya şifre hatalı")
                        case 403:
                            onFailed("Bu işlem için yetkiniz yok")
                        case 404:
                            onFailed("İstenilen kaynak bulunamadı")
                        case 500:
                            onFailed("Sunucu hatası oluştu")
                        default:
                            onFailed("İstek başarısız: HTTP \(httpResponse.statusCode)")
                        }
                    }
                } else {
                    onFailed("İstek başarısız: HTTP \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


