import Foundation
import Combine

final class PostDetailViewModel: ObservableObject {
    @Published var post: PostDetailModel?
    @Published var comments: [CommentModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let postService: IPostService
    private let commentService: ICommentService
    private let postId: Int
    
    init(postId: Int, postService: IPostService = PostService(), commentService: ICommentService = CommentService()) {
        self.postId = postId
        self.postService = postService
        self.commentService = commentService
    }
    
    func fetchPost() {
        isLoading = true
        postService.getPostById(postId: postId) { [weak self] post in
            DispatchQueue.main.async {
                if let post = post {
                    self?.post = post
                    self?.isLoading = false
                } else {
                    self?.errorMessage = "Gönderi bulunamadı"
                    self?.isLoading = false
                }
            }
        } onFailed: { [weak self] error in
            DispatchQueue.main.async {
                self?.errorMessage = "Gönderi yüklenirken bir hata oluştu: \(error)"
                self?.isLoading = false
            }
        }
    }
    
    func fetchComments() {
        commentService.getCommentsByPostId(postId: postId) { [weak self] comments in
            DispatchQueue.main.async {
                self?.comments = comments ?? []
            }
        } onFailed: { [weak self] error in
            DispatchQueue.main.async {
                self?.errorMessage = error
            }
        }
    }
    
    func createComment(comment: String) {
        let model = CommentRequestModel(postId: postId, comment: comment)
        commentService.createComment(model: model) { [weak self] comment in
            if comment != nil {
                self?.fetchComments()
            }
        } onFailed: { [weak self] error in
            DispatchQueue.main.async {
                self?.errorMessage = error
            }
        }
    }
} 
