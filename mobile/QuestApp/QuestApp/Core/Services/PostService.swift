
final class PostService: IPostService {
    private let networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager.shared
    }
    
    func getAllPosts(completion: @escaping ([PostListModel]?) -> Void, onFailed: @escaping (String) -> Void) {
        networkManager.request(path: "/posts", method: .get) { (response: [PostListModel]?) in
            completion(response)
        } onFailed: { error in
            onFailed(error)
        }
    }
    
    func getPostById(postId: Int, completion: @escaping (PostDetailModel?) -> Void, onFailed: @escaping (String) -> Void) {
        networkManager.request(path: "/posts/\(postId)", method: .get) { (response: PostDetailModel?) in
            completion(response)
        } onFailed: { error in
            onFailed(error)
        }
    }
    
    func createPost(model: PostRequestModel, completion: @escaping (PostDetailModel?) -> Void, onFailed: @escaping (String) -> Void) {
        networkManager.request(path: "/posts", method: .post, model: model) { (response: PostDetailModel?) in
            completion(response)
        } onFailed: { error in
            onFailed(error)
        }
    }
    
    func updatePost(postId: Int, model: UpdatePostModel, completion: @escaping (PostDetailModel?) -> Void, onFailed: @escaping (String) -> Void) {
        networkManager.request(path: "/posts/\(postId)", method: .put, model: model) { (response: PostDetailModel?) in
            completion(response)
        } onFailed: { error in
            onFailed(error)
        }
    }
    
    func deletePost(postId: Int, completion: @escaping (Bool) -> Void, onFailed: @escaping (String) -> Void) {
        networkManager.request(path: "/posts/\(postId)", method: .delete) { (response: EmptyResponse?) in
            completion(true)
        } onFailed: { error in
            onFailed(error)
        }
    }
    
    func getPostsByUserId(userId: Int, completion: @escaping ([PostListModel]?) -> Void, onFailed: @escaping (String) -> Void) {
        networkManager.request(path: "/posts/user/\(userId)", method: .get) { (response: [PostListModel]?) in
            completion(response)
        } onFailed: { error in
            onFailed(error)
        }
    }
}
