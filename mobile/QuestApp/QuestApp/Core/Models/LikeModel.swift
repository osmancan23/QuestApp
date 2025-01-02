struct LikeModel: Codable, Identifiable, Hashable {
    let id: Int
    let postId: Int
    let userId: Int
}

struct LikeRequestModel: Codable {
    let postId: Int
} 
