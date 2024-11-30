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
        postService.createPost(onSuccess: { response in
            print("Post created")
            self.isPostCreated = true
            self.content = ""
        }, onFailed: { error in
                print("Error")
            self.isPostCreated = false
            }, post: CreatePostModel(id: 9, title: "Title", content: content, userId: 1))
    }
}
