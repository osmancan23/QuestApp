final class CommentService: ICommentService {
    private let networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager.shared
    }
    
    func getCommentsByPostId(postId: Int, completion: @escaping ([CommentModel]?) -> Void, onFailed: @escaping (String) -> Void) {
        networkManager.request(path: "/comments?postId=\(postId)", method: .get) { (response: [CommentModel]?) in
            completion(response)
        } onFailed: { error in
            onFailed(error)
        }
    }
    
    func createComment(model: CommentRequestModel, completion: @escaping (CommentModel?) -> Void, onFailed: @escaping (String) -> Void) {
        networkManager.request(path: "/comments", method: .post, model: model) { (response: CommentModel?) in
            completion(response)
        } onFailed: { error in
            onFailed(error)
        }
    }
    
    func deleteComment(commentId: Int, completion: @escaping (Bool) -> Void, onFailed: @escaping (String) -> Void) {
        networkManager.request(path: "/comments/\(commentId)", method: .delete) { (response: EmptyResponse?) in
            completion(true)
        } onFailed: { error in
            onFailed(error)
        }
    }
} 
