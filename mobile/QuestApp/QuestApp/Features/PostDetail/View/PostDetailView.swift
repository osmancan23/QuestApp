import SwiftUI

struct PostDetailView: View {
    let postId: Int
    @StateObject private var viewModel: PostDetailViewModel
    @State private var newComment: String = ""
    
    init(postId: Int) {
        self.postId = postId
        self._viewModel = StateObject(wrappedValue: PostDetailViewModel(postId: postId))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
            } else if let post = viewModel.post {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Kullanıcı bilgileri
                        HStack(alignment: .center) {
                            Image("login")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text(post.userName ?? "Unknown")
                                    .font(.headline)
                                Text(post.createdAt?.formatDate ?? "-")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // Post içeriği
                        Text(post.content)
                            .font(.body)
                            .padding(.horizontal)
                        
                        // Post resmi
                        if let imageUrl = post.imageUrl, !imageUrl.isEmpty {
                            AsyncImage(url: URL(string: imageUrl)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: 300)
                                    .cornerRadius(12)
                            } placeholder: {
                                ProgressView()
                            }
                            .padding(.horizontal)
                        }
                        
                        // Etkileşim butonları
                        HStack(spacing: 20) {
                            Button(action: {
                                if post.isLiked {
                                    if let likeId = viewModel.getCurrentUserLikeId() {
                                        viewModel.unlikePost(likeId: likeId)
                                    }
                                } else {
                                    viewModel.likePost()
                                }
                            }) {
                                HStack {
                                    Image(systemName: post.isLiked ? "heart.fill" : "heart")
                                        .foregroundColor(post.isLiked ? .red : .gray)
                                    Text("\(post.likes?.count ?? 0)")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            HStack {
                                Image(systemName: "bubble.left")
                                    .foregroundColor(.gray)
                                Text("\(viewModel.comments.count)")
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Yorumlar başlığı
                        Text("Yorumlar")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        // Yorumlar listesi
                        if viewModel.comments.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "bubble.left")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("Henüz yorum yapılmamış")
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                        } else {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.comments) { comment in
                                    CommentRow(comment: comment)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
                
                // Yorum yazma alanı
                VStack(spacing: 0) {
                    Divider()
                    HStack(spacing: 12) {
                        TextField("Yorum yaz...", text: $newComment)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                        
                        Button(action: {
                            if !newComment.isEmpty {
                                viewModel.createComment(comment: newComment)
                                newComment = ""
                                hideKeyboard()
                            }
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(newComment.isEmpty ? .gray : .blue)
                                .font(.system(size: 20))
                                .frame(width: 44, height: 44)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                        .disabled(newComment.isEmpty)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(Color(.systemBackground))
                .shadow(radius: 2, y: -1)
                
            } else {
                // Hata durumu
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    
                    Text(viewModel.errorMessage ?? "Gönderi yüklenirken bir hata oluştu")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                    
                    Button("Tekrar Dene") {
                        viewModel.fetchPost()
                        viewModel.fetchComments()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchPost()
            viewModel.fetchComments()
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

struct CommentRow: View {
    let comment: CommentModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image("login")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                Text("\(comment.userName)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(comment.content)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

// Klavyeyi gizlemek için extension
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
} 
