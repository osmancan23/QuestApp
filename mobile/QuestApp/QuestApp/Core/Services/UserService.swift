import Foundation

protocol IUserService {
    func getCurrentUser() async throws -> User
}

class UserService: IUserService {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getCurrentUser() async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            networkManager.request(
                path: "/users/me",
                method: .get
            ) { (response: User?) in
                if let user = response {
                    continuation.resume(returning: user)
                } else {
                    continuation.resume(throwing: NetworkError.decodingError)
                }
            } onFailed: { error in
                continuation.resume(throwing: NetworkError.networkError)
            }
        }
    }
} 
