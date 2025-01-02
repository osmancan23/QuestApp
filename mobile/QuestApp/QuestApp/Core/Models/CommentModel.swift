struct CommentModel: Codable, Identifiable {
    let id: Int
    let postId: Int
    let userId: Int
    let comment: String
}

struct CommentRequestModel: Codable {
    let postId: Int
    let comment: String
} 
