import Foundation

final class LikeService: ILikeService {
    private let networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager.shared
    }
    
    func likePost(postId: Int, completion: @escaping (LikeModel?) -> Void, onFailed: @escaping (String) -> Void) {
        let model = LikeRequestModel(postId: postId)
        networkManager.request(path: "/likes", method: .post, model: model) { (response: LikeModel?) in
            completion(response)
        } onFailed: { error in
            onFailed(error)
        }
    }
    
    func unlikePost(likeId: Int, completion: @escaping (Bool) -> Void, onFailed: @escaping (String) -> Void) {
        networkManager.request(path: "/likes/\(likeId)", method: .delete, shouldParse: false) { (response: EmptyResponse?) in
            completion(true)
        } onFailed: { error in
            onFailed(error)
        }
    }
} 
