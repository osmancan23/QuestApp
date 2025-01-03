//
//  CreatePostModel.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 28.11.2024.
//

import Foundation

struct CreatePostModel: Codable {
    let content: String
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case content, imageUrl
    }
}
