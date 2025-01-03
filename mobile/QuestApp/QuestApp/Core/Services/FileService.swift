import Foundation
import UIKit

protocol IFileService {
    func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void, onFailed: @escaping (String) -> Void)
}

final class FileService: IFileService {
    private let networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager.shared
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void, onFailed: @escaping (String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            onFailed("Resim verisi oluşturulamadı")
            return
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "\(NetworkManager.baseURL)/files/upload")!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Dosya verisi
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Son boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        if let token = networkManager.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                onFailed(error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                onFailed("Geçersiz sunucu yanıtı")
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data, let urlString = String(data: data, encoding: .utf8) {
                    completion(urlString)
                } else {
                    onFailed("Sunucu yanıtı okunamadı")
                }
            } else {
                onFailed("Resim yüklenemedi: HTTP \(httpResponse.statusCode)")
            }
        }.resume()
    }
} 
