protocol IPostService {
    func getAllPosts(completion: @escaping ([PostListModel]?) -> Void, onFailed: @escaping (String) -> Void)
    func getPostById(postId: Int, completion: @escaping (PostDetailModel?) -> Void, onFailed: @escaping (String) -> Void)
    func createPost(model: PostRequestModel, completion: @escaping (PostDetailModel?) -> Void, onFailed: @escaping (String) -> Void)
    func deletePost(postId: Int, completion: @escaping (Bool) -> Void, onFailed: @escaping (String) -> Void)
}
