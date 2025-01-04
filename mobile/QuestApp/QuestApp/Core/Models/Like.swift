import Foundation

struct Like: Codable, Identifiable {
    let id: Int
    let userId: Int
    let postId: Int
    let createdAt: Date?
    
   
} 
