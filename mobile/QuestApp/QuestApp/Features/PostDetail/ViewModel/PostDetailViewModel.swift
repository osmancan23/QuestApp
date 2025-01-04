import Foundation
import Combine

final class PostDetailViewModel: ObservableObject {
    @Published var post: PostDetailModel?
    @Published var comments: [CommentModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let postService: IPostService
    private let commentService: ICommentService
    private let likeService: ILikeService
    private let postId: Int
    
    init(postId: Int, 
         postService: IPostService = PostService() as! IPostService,
         commentService: ICommentService = CommentService(),
         likeService: ILikeService = LikeService()
         ) {
        self.postId = postId
        self.postService = postService
        self.commentService = commentService
        self.likeService = likeService
        
        fetchComments()
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
    
    func isLikedByCurrentUser() -> Bool {
        guard let currentUserId = UserDefaults.standard.integer(forKey: "userId") as Int?,
              let likes = post?.likes else {
            return false
        }
        return likes.contains { $0.userId == currentUserId }
    }
    
    func getCurrentUserLikeId() -> Int? {
        guard let currentUserId = UserDefaults.standard.integer(forKey: "userId") as Int?,
              let likes = post?.likes else {
            return nil
        }
        return likes.first { $0.userId == currentUserId }?.id
    }
    
    func likePost() {
        guard let userId = UserDefaults.standard.integer(forKey: "userId") as Int? else {
            return
        }
        
        let likeRequest = LikeCreateRequest(postId: postId, userId: userId)
        
        Task {
            do {
                let like = try await likeService.createLike(request: likeRequest)
                await MainActor.run {
                    if post?.likes == nil {
                        post?.likes = []
                    }
                    post?.likes?.append(like)
                }
            } catch {
                print("Error liking post: \(error)")
            }
        }
    }
    
    func unlikePost(likeId: Int) {
        Task {
            do {
                try await likeService.deleteLike(id: likeId)
                await MainActor.run {
                    post?.likes?.removeAll { $0.id == likeId }
                }
            } catch {
                print("Error unliking post: \(error)")
            }
        }
    }
} 
