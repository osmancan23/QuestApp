//
//  PostCreateViewModel.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 30.11.2024.
//

import Foundation
import SwiftUI


final class PostCreateViewModel: ObservableObject {

    @Published var content: String = ""
    let postService: IPostService = PostService()
    
    @Published var isPostCreated: Bool = false


    func sharePost() {
        postService.createPost(onSuccess: { _ in
            print("Post created")
            self.isPostCreated = true
            self.content = ""
        }, onFailed: { error in
            print(error)
            self.isPostCreated = false
            }, post: CreatePostModel(id: 13, title: "Title", content: content, userId: 1))
    }
}
