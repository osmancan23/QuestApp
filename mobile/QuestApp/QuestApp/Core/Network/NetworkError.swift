//
//  NetworkError.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 2.01.2025.
//

import Foundation


enum NetworkError: Error {
    case unauthorized
    case badRequest
    case serverError
    case networkError
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .unauthorized:
            return "Oturum süreniz doldu. Lütfen tekrar giriş yapın."
        case .badRequest:
            return "Geçersiz istek."
        case .serverError:
            return "Sunucu hatası oluştu. Lütfen daha sonra tekrar deneyin."
        case .networkError:
            return "İnternet bağlantınızı kontrol edin."
        case .decodingError:
            return "Veri işlenirken bir hata oluştu."
        }
    }
}
