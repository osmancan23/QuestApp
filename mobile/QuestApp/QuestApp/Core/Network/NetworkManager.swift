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
    private let baseURL = "http://localhost:8080"
    private let authManager: AuthManager
    
    init(authManager: AuthManager = AuthManager()) {
        self.authManager = authManager
    }
    
    // Token helper method to standardize token handling
    private func getAuthorizationHeader() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        if let tokenData = KeychainHelper.shared.read(for: "authToken"),
           let token = String(data: tokenData, encoding: .utf8) {
            // Remove any existing "Bearer " prefix
            let cleanToken = token.replacingOccurrences(of: "Bearer ", with: "")
            headers["Authorization"] = "Bearer \(cleanToken)"
        }
        
        return headers
    }
    
    // Generic request method
    func request<T: Decodable, R: Encodable>(
        path: String,
        method: HTTPMethod,
        model: R? = nil,
        shouldParse: Bool = true,
        completion: @escaping (T?) -> Void,
        onFailed: @escaping (String) -> Void
    ) {
        let url = "\(baseURL)\(path)"
        let headers = getAuthorizationHeader()
        
        // Create request
        var request = URLRequest(url: URL(string: url)!)
        request.method = method
        request.headers = headers
        
        // Debug için request detayları
        print("Request URL: \(url)")
        print("Request Method: \(method)")
        print("Request Headers: \(headers)")
        
        // Body handling for non-GET requests
        if method != .get, let model = model {
            do {
                request.httpBody = try JSONEncoder().encode(model)
            } catch {
                onFailed("Encoding error: \(error.localizedDescription)")
                return
            }
        }
        
        AF.request(request).responseData { [weak self] response in
            print("Response Status Code: \(String(describing: response.response?.statusCode))")
            if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
            }
            
            // Status code kontrolü
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 401:
                    self?.authManager.handleUnauthorized()
                    onFailed(NetworkError.unauthorized.localizedDescription)
                    return
                case 400:
                    onFailed(NetworkError.badRequest.localizedDescription)
                    return
                case 500...599:
                    onFailed(NetworkError.serverError.localizedDescription)
                    return
                default:
                    break
                }
            }
            
            switch response.result {
            case .success(let data):
                if shouldParse {
                    do {
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(decodedResponse)
                    } catch {
                        print("Parsing Error: \(error)")
                        onFailed(NetworkError.decodingError.localizedDescription)
                    }
                } else {
                    completion(true as? T)
                }
            case .failure(let error):
                print("Network Error: \(error)")
                onFailed(NetworkError.networkError.localizedDescription)
            }
        }
    }
    
    // GET requests overload
    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        shouldParse: Bool = true,
        completion: @escaping (T?) -> Void,
        onFailed: @escaping (String) -> Void
    ) {
        if method == .get {
            let url = "\(baseURL)\(path)"
            let headers = getAuthorizationHeader()
            
            print("GET Request URL: \(url)")
            print("GET Request Headers: \(headers)")
            
            AF.request(url, method: method, headers: headers).responseData { [weak self] response in
                print("GET Response Status Code: \(String(describing: response.response?.statusCode))")
                if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                    print("GET Response Data: \(responseString)")
                }
                
                // Status code kontrolü
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 401:
                        self?.authManager.handleUnauthorized()
                        onFailed(NetworkError.unauthorized.localizedDescription)
                        return
                    case 400:
                        onFailed(NetworkError.badRequest.localizedDescription)
                        return
                    case 500...599:
                        onFailed(NetworkError.serverError.localizedDescription)
                        return
                    default:
                        break
                    }
                }
                
                switch response.result {
                case .success(let data):
                    if shouldParse {
                        do {
                            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                            completion(decodedResponse)
                        } catch {
                            print("GET Parsing Error: \(error)")
                            onFailed(NetworkError.decodingError.localizedDescription)
                        }
                    } else {
                        completion(true as? T)
                    }
                case .failure(let error):
                    print("Network Error: \(error)")
                    onFailed(NetworkError.networkError.localizedDescription)
                }
            }
        } else {
            request(path: path, method: method, model: EmptyRequest(), shouldParse: shouldParse, completion: completion, onFailed: onFailed)
        }
    }
    
    private func handleResponse<T: Decodable>(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        shouldParse: Bool,
        completion: @escaping (Result<T?, Error>) -> Void
    ) {
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 401:
                authManager.handleUnauthorized()
                completion(.failure(NetworkError.unauthorized))
            case 400:
                completion(.failure(NetworkError.badRequest))
            case 500...599:
                completion(.failure(NetworkError.serverError))
            default:
                break
            }
        }
        
        if let error = error {
            completion(.failure(NetworkError.networkError))
            return
        }
        
        guard let data = data else {
            completion(.failure(NetworkError.networkError))
            return
        }
        
        if shouldParse {
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        } else {
            completion(.success(nil))
        }
    }
}

// Empty struct for requests without body
struct EmptyRequest: Encodable {}

// Empty response struct for requests that don't need parsing
struct EmptyResponse: Decodable {}


