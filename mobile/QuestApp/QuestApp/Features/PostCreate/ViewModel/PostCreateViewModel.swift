//
//  PostCreateViewModel.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 30.11.2024.
//

import Foundation
import SwiftUI


final class PostCreateViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let postService: IPostService
    
    init(postService: IPostService = PostService()) {
        self.postService = postService
    }
    
    func sharePost(completion: @escaping (Bool) -> Void) {
        isLoading = true
        let model = PostRequestModel(title: title, content: content)
        
        postService.createPost(model: model) { [weak self] post in
            DispatchQueue.main.async {
                self?.isLoading = false
                if post != nil {
                    completion(true)
                } else {
                    self?.errorMessage = "Gönderi oluşturulamadı"
                    completion(false)
                }
            }
        } onFailed: { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.errorMessage = error
                completion(false)
            }
        }
    }
}
