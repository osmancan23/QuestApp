struct NavigationViewBuilder {
    static func view(for destination: Router.Destination, authManager: AuthManager) -> some View {
        switch destination {
        case .login:
            return AnyView(LoginView(authManager: authManager))
        case .register:
            return AnyView(RegisterView(authManager: authManager))
        case .feed:
            return AnyView(FeedView(authManager: authManager))
        case .postDetail(let postId):
            return AnyView(PostDetailView(postId: postId))
        case .postCreate:
            return AnyView(CreatePostView(isPresented: .constant(true), onPost: { _, _ in }))
        case .profile:
            return AnyView(ProfileView(authManager: authManager))
        }
    }
}

// NavigationViewBuilder'ı View protokolüne uygun hale getiriyoruz
struct NavigationViewBuilder: View {
    let destination: Router.Destination
    let authManager: AuthManager
    
    var body: some View {
        NavigationViewBuilder.view(for: destination, authManager: authManager)
    }
} 