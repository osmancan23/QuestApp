//
//  FeedViewModel.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 28.11.2024.
//

import Foundation

final class FeedViewModel: ObservableObject {
    @Published var posts: [PostModel] = []
    
    
    let _postService: IPostService = PostService()
    
    func fetchPosts ()  {
        
        _postService.fetchAllPosts { response in
            self.posts = response
        } onFailed: { error in
            print(error)
        }

       
    }


}
