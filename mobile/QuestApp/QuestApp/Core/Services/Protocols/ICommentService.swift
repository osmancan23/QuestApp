protocol ICommentService {
    func getCommentsByPostId(postId: Int, completion: @escaping ([CommentModel]?) -> Void, onFailed: @escaping (String) -> Void)
    func createComment(model: CommentRequestModel, completion: @escaping (CommentModel?) -> Void, onFailed: @escaping (String) -> Void)
    func deleteComment(commentId: Int, completion: @escaping (Bool) -> Void, onFailed: @escaping (String) -> Void)
} 