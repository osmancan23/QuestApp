//
//  NetworkManager.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 28.11.2024.
//

import Foundation
import Alamofire



final class NetworkManager {
    static let shared = NetworkManager()
    static let baseURL = "http://localhost:8080"
    
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
                onFailed("İstek başarısız: HTTP \(httpResponse.statusCode)")
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


