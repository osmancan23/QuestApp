//
//  CreatePostModel.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 28.11.2024.
//

import Foundation

struct CreatePostModel: Codable {
    let id: Int
    let title, content: String
    let userId: Int

    enum CodingKeys: String, CodingKey {
        case id, title, content, userId
        
    }
}
