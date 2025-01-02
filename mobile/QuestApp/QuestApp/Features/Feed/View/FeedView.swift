import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel: FeedViewModel
    @ObservedObject var authManager: AuthManager
    @State private var showingCreatePost = false
    @State private var newPostTitle = ""
    @State private var newPostContent = ""
    
    init(authManager: AuthManager) {
        self._viewModel = StateObject(wrappedValue: FeedViewModel())
        self.authManager = authManager
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.posts) { post in
                            PostCard(post: post, onLike: { postId in
                                viewModel.likePost(postId: postId)
                            }, onUnlike: { likeId in
                                viewModel.unlikePost(likeId: likeId)
                            })
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Ana Sayfa")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingCreatePost = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingCreatePost) {
            CreatePostView(isPresented: $showingCreatePost, onPost: { title, content in
                viewModel.createPost(title: title, content: content)
            })
        }
        .onAppear {
            viewModel.fetchPosts()
        }
        .alert("Hata", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("Tamam", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

struct PostCard: View {
    let post: PostModel
    let onLike: (Int) -> Void
    let onUnlike: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(post.title)
                .font(.headline)
            
            Text(post.content)
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack {
                Button(action: {
                    if let existingLike = post.likes?.first {
                        onUnlike(existingLike.id)
                    } else {
                        onLike(post.id)
                    }
                }) {
                    HStack {
                        Image(systemName: post.likes?.isEmpty == false ? "heart.fill" : "heart")
                            .foregroundColor(post.likes?.isEmpty == false ? .red : .gray)
                        Text("\(post.likes?.count ?? 0)")
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: PostDetailView(postId: post.id)) {
                    HStack {
                        Image(systemName: "bubble.right")
                        Text("\(post.comments?.count ?? 0)")
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct CreatePostView: View {
    @Binding var isPresented: Bool
    let onPost: (String, String) -> Void
    
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Yeni Gönderi")) {
                    TextField("Başlık", text: $title)
                    TextEditor(text: $content)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Gönderi Oluştur")
            .navigationBarItems(
                leading: Button("İptal") {
                    isPresented = false
                },
                trailing: Button("Paylaş") {
                    onPost(title, content)
                    isPresented = false
                }
                .disabled(title.isEmpty || content.isEmpty)
            )
        }
    }
} 