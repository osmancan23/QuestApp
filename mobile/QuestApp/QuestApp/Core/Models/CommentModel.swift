struct CommentModel: Codable, Identifiable {
    let id: Int
    let postId: Int
    let userId: Int
    let content: String
    let userName: String
}

struct CommentRequestModel: Codable {
    let postId: Int
    let comment: String
} 
