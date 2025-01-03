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
                // Post detayı
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(post.content)
                            .font(.body)
                            .padding(.horizontal)
                        
                        if let imageUrl = post.imageUrl, !imageUrl.isEmpty {
                            AsyncImage(url: URL(string: imageUrl)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: 200)
                            } placeholder: {
                                ProgressView()
                            }
                            .padding(.horizontal)
                        }
                        
                        HStack {
                            Image(systemName: post.likes?.isEmpty == false ? "heart.fill" : "heart")
                                .foregroundColor(post.likes?.isEmpty == false ? .red : .gray)
                            Text("\(post.likes?.count ?? 0) beğeni")
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Image(systemName: "bubble.right")
                            Text("\(viewModel.comments.count) yorum")
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Yorumlar
                        if viewModel.comments.isEmpty {
                            Text("Henüz yorum yapılmamış")
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            ForEach(viewModel.comments) { comment in
                                CommentRow(comment: comment)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                
                // Yorum yazma alanı
                VStack {
                    Divider()
                    HStack {
                        TextField("Yorum yaz...", text: $newComment)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 8)
                        
                        Button(action: {
                            if !newComment.isEmpty {
                                viewModel.createComment(comment: newComment)
                                newComment = ""
                                hideKeyboard()
                            }
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.blue)
                                .padding(8)
                        }
                        .disabled(newComment.isEmpty)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
                .background(Color(.systemBackground))
                .shadow(radius: 2, y: -2)
            } else {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                        .padding()
                    
                    Text(viewModel.errorMessage ?? "Gönderi yüklenirken bir hata oluştu")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                    
                    Button("Tekrar Dene") {
                        viewModel.fetchPost()
                        viewModel.fetchComments()
                    }
                    .padding()
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
        VStack(alignment: .leading, spacing: 8) {
            Text("@user\(comment.userId)")
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text(comment.comment)
                .font(.body)
            
            Text(comment.userId.description ?? "")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Divider()
        }
        .padding(.vertical, 4)
    }
}

// Klavyeyi gizlemek için extension
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
} 
