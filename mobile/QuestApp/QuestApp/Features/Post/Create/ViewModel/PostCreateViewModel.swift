import Foundation
import SwiftUI

final class PostCreateViewModel: ObservableObject {
    @Published var content: String = ""
    @Published var selectedImage: UIImage?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    private let postService: IPostService
    private let fileService: IFileService
    
    init(postService: IPostService = PostService(), fileService: IFileService = FileService()) {
        self.postService = postService
        self.fileService = fileService
    }
    
    func sharePost() {
        guard !content.isEmpty else {
            errorMessage = "İçerik boş olamaz"
            return
        }
        
        isLoading = true
        
        if let image = selectedImage {
            // Önce resmi yükle
            fileService.uploadImage(image) { [weak self] imageUrl in
                self?.createPost(imageUrl: imageUrl)
            } onFailed: { [weak self] error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = "Resim yüklenemedi: \(error)"
                }
            }
        } else {
            // Resim yoksa direkt post oluştur
            createPost(imageUrl: nil)
        }
    }
    
    private func createPost(imageUrl: String?) {
        let model = PostRequestModel(content: content,
                                   imageUrl: imageUrl)
        
        postService.createPost(model: model) { [weak self] response in
            DispatchQueue.main.async {
                self?.isLoading = false
                if response != nil {
                    self?.successMessage = "Gönderi başarıyla paylaşıldı"
                    self?.clearInputs()
                } else {
                    self?.errorMessage = "Gönderi paylaşılamadı"
                }
            }
        } onFailed: { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.errorMessage = "Gönderi paylaşılamadı: \(error)"
            }
        }
    }
    
    private func clearInputs() {
        content = ""
        selectedImage = nil
        errorMessage = nil
        successMessage = nil
    }
} 
