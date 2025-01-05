import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var postCount: Int = 0
    @Published var likeCount: Int = 0
    @Published var posts: [PostListModel] = []

    private let userService: IUserService
    private let postService: IPostService
    
    init(userService: IUserService = UserService(), postService: IPostService = PostService()) {
        self.userService = userService
        self.postService = postService
    }
    
    @MainActor
    func fetchPosts() {
        isLoading = true
        postService.getPostsByUserId(userId: user!.id ) { [weak self] posts in
            DispatchQueue.main.async {
                print("Posts: \(posts)")
                self?.posts = posts ?? []
                self?.isLoading = false
            }
        } onFailed: { [weak self] error in
            DispatchQueue.main.async {
                print(error)
                self?.errorMessage = error
                self?.isLoading = false

            }
        }


    }
    
    @MainActor
    func fetchUserData() {
        isLoading = true
        
        Task {
            do {
                user = try await userService.getCurrentUser()
                fetchPosts()
                await fetchUserStats()
                isLoading = false
            } catch {
                errorMessage = "Kullanıcı bilgileri yüklenirken bir hata oluştu"
                isLoading = false
            }
        }
    }
    
    @MainActor
    private func fetchUserStats() async {
        guard let userId = user?.id else { return }
        
        do {
           /* let posts = try await postService.getUserPosts(userId: userId)
            postCount = posts.count
            likeCount = posts.reduce(0) { $0 + ($1.likes?.count ?? 0) }*/
        } catch {
            errorMessage = "İstatistikler yüklenirken bir hata oluştu"
        }
    }
} 
