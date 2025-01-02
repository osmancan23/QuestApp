//
//  FeedViewModel.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 28.11.2024.
//

import Foundation

final class FeedViewModel: ObservableObject {
    @Published var posts: [PostListModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let postService: IPostService
    private let likeService: ILikeService
    
    init(postService: IPostService = PostService(), likeService: ILikeService = LikeService()) {
        self.postService = postService
        self.likeService = likeService
    }
    
    func fetchPosts() {
        isLoading = true
        postService.getAllPosts { [weak self] posts in
            DispatchQueue.main.async {
                print("Posts: \(posts)")
                self?.posts = posts ?? []
                self?.isLoading = false
            }
        } onFailed: { [weak self] error in
            DispatchQueue.main.async {
                print(error)
                self?.errorMessage = error
                self?.isLoading = false
                
            }
        }
        
        
    }
    
    func createPost(title: String, content: String) {
        let model = PostRequestModel(title: title, content: content)
        postService.createPost(model: model) { [weak self] post in
            if post != nil {
                self?.fetchPosts()
            }
        } onFailed: { [weak self] error in
            DispatchQueue.main.async {
                self?.errorMessage = error
            }
        }
    }
    
    func deletePost(postId: Int) {
        postService.deletePost(postId: postId) { [weak self] success in
            if success {
                self?.fetchPosts()
            }
        } onFailed: { [weak self] error in
            DispatchQueue.main.async {
                self?.errorMessage = error
            }
        }
    }
    
    func likePost(postId: Int) {
        likeService.likePost(postId: postId) { [weak self] like in
            if like != nil {
                self?.fetchPosts()
            }
        } onFailed: { [weak self] error in
            DispatchQueue.main.async {
                self?.errorMessage = error
            }
        }
    }
    
    func unlikePost(likeId: Int) {
        likeService.unlikePost(likeId: likeId) { [weak self] success in
            if success {
                self?.fetchPosts()
            }
        } onFailed: { [weak self] error in
            DispatchQueue.main.async {
                self?.errorMessage = error
            }
        }
    }
}
