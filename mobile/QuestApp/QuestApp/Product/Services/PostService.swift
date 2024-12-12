//
//  PostService.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 28.11.2024.
//

import Foundation

protocol IPostService {

    var _networkManager: NetworkManager { get }

    func fetchAllPosts(onSuccess: @escaping ([PostModel]) -> Void, onFailed: @escaping (String) -> Void)

    func fetchPost(id: Int) -> PostModel?

    func createPost(onSuccess: @escaping (PostModel?) -> Void, onFailed: @escaping (String) -> Void, post: CreatePostModel)

    func updatePost(post: PostModel)

    func deletePost(id: Int)

}

class PostService: IPostService {
    
    internal let _networkManager: NetworkManager = NetworkManager()


    func fetchAllPosts(onSuccess: @escaping ([PostModel]) -> Void, onFailed: @escaping (String) -> Void) {
        _networkManager.fetch(onSuccess: onSuccess, onFailed: onFailed, path: Route.posts.value)
    }

    func fetchPost(id: Int) -> PostModel? {
        return nil
    }

    func createPost(onSuccess: @escaping (PostModel?) -> Void, onFailed: @escaping (String) -> Void, post: CreatePostModel) {
        _networkManager.post(onSuccess: onSuccess, onFailed: onFailed, path: Route.posts.value , body: post)
    }

    func updatePost(post: PostModel) {
    }

    func deletePost(id: Int) {
      

    }



}



