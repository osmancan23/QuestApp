protocol ILikeService {
    func likePost(postId: Int, completion: @escaping (LikeModel?) -> Void, onFailed: @escaping (String) -> Void)
    func unlikePost(likeId: Int, completion: @escaping (Bool) -> Void, onFailed: @escaping (String) -> Void)
} 