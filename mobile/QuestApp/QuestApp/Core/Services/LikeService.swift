import Foundation

protocol ILikeService {
    func createLike(request: LikeCreateRequest) async throws -> Like
    func deleteLike(id: Int) async throws
}

class LikeService: ILikeService {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func createLike(request: LikeCreateRequest) async throws -> Like {
        return try await withCheckedThrowingContinuation { continuation in
            networkManager.request(
                path: "/likes",
                method: .post,
                model: request
            ) { (response: Like?) in
                if let like = response {
                    continuation.resume(returning: like)
                } else {
                    continuation.resume(throwing: NetworkError.decodingError)
                }
            } onFailed: { error in
                continuation.resume(throwing: NetworkError.networkError)
            }
        }
    }
    
    func deleteLike(id: Int) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            networkManager.request(
                path: "/likes/\(id)",
                method: .delete,
                shouldParse: false
            ) { (response: EmptyResponse?) in
                continuation.resume()
            } onFailed: { error in
                continuation.resume(throwing: NetworkError.networkError)
            }
        }
    }
}

struct LikeCreateRequest: Codable {
    let postId: Int
    let userId: Int
}

