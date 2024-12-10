//
//  PostModel.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 25.11.2024.
//

import Foundation

struct PostModel: Codable, Identifiable, Hashable {
    let id: Int // Opsiyonel yerine zorunlu yaptık
    let userId: Int?
    let userName, title, content: String
    let likes: [LikeModel]?
}

struct LikeModel: Codable, Identifiable, Hashable {
    let id: Int
    let userID, postID: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case postID = "postId"
    }
}
