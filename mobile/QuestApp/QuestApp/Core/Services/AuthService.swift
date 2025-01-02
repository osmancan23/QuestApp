import Foundation

protocol IAuthService {
    func login(model: AuthRequestModel, completion: @escaping (AuthResponseModel?) -> Void, onFailed: @escaping (String) -> Void)
    func register(model: AuthRequestModel, completion: @escaping (AuthResponseModel?) -> Void, onFailed: @escaping (String) -> Void)
    func validateToken(completion: @escaping (Result<Void, Error>) -> Void)
}

final class AuthService: IAuthService {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func login(model: AuthRequestModel, completion: @escaping (AuthResponseModel?) -> Void, onFailed: @escaping (String) -> Void) {
        networkManager.request(
            path: "/auth/login",
            method: .post,
            model: model,
            completion: completion,
            onFailed: onFailed
        )
    }
    
    func register(model: AuthRequestModel, completion: @escaping (AuthResponseModel?) -> Void, onFailed: @escaping (String) -> Void) {
        networkManager.request(
            path: "/auth/register",
            method: .post,
            model: model,
            completion: completion,
            onFailed: onFailed
        )
    }
    
    func validateToken(completion: @escaping (Result<Void, Error>) -> Void) {
        networkManager.request(
            path: "/posts",
            method: .get,
            shouldParse: false,
            completion: { (response: EmptyResponse?) in
                completion(.success(()))
            },
            onFailed: { error in
                if error.contains("401") {
                    completion(.failure(NetworkError.unauthorized))
                } else {
                    completion(.failure(NetworkError.networkError))
                }
            }
        )
    }
}

struct AuthRequestModel: Codable {
    let userName: String
    let password: String
}

struct AuthResponseModel: Codable {
    let accessToken: String
} 
