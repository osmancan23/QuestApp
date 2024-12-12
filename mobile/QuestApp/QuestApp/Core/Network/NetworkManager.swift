//
//  NetworkManager.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 28.11.2024.
//


import Alamofire
import Foundation


struct NetworkManager {


    // MARK: - Fetch (GET Request)
    func fetch<T: Codable>(
        onSuccess: @escaping (T) -> Void,
        onFailed: @escaping (String) -> Void,
        path: String,
        parameters: Parameters? = nil
    ) {
        let urlString = Route.baseUrl + path

        guard let url = urlString.asUrl else {
            onFailed("Invalid URL")
            return
        }

        AF.request(url, method: .get, parameters: parameters, headers: AppConstants.headers)
            .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                onSuccess(value)
            case .failure(let error):
                onFailed(error.localizedDescription)
            }
        }
    }

    // MARK: - POST Request


    /// POST
    /// - Parameters:
    ///     - T: Parse Model
    ///   - onSuccess: When the request is successful, this block will be executed.
    ///   - onFailed: When the request is failed, this block will be executed.
    ///   - route: Url path.
    ///   - body: The data to be sent to the server.
    func post<T: Codable, R: Encodable>(
        onSuccess: @escaping (T?) -> Void,
        onFailed: @escaping (String) -> Void,
        path: String,
        body: R? = nil,
        parseModel: T.Type? = nil
    ) {
        let urlString = Route.baseUrl + path

        guard let url = urlString.asUrl else {
            onFailed("Invalid URL")
            return
        }

        // Gönderilecek veriyi encode ediyoruz.
        guard let body = body else {
            onFailed("Body is nil.")
            return
        }

        let request = AF.request(url,
                                 method: .post,
                                 parameters: body,
                                 encoder: JSONParameterEncoder.default,
                                 headers: AppConstants.headers)

        if let parseModel = parseModel {
            print("parse model var")
            // Eğer parse modeli varsa, yanıtı bu modele göre parse et
            request.responseDecodable(of: parseModel.self) { response in
                switch response.result {
                case .success(let value):
                    onSuccess(value)
                case .failure(let error):
                    onFailed(error.localizedDescription)
                }
            }
        } else {
            print("parse model yok")
            // Eğer parse modeli yoksa, yalnızca durum kodunu kontrol et
            request.response { response in
                if let statusCode = response.response?.statusCode, (200...299).contains(statusCode) {
                    onSuccess(nil) // Parse modeli olmadığı için `nil` dönebiliriz
                } else {
                    onFailed("Failed with status code: \(response.response?.statusCode ?? 0)")
                }
            }
        }
    }




    // MARK: - PUT Request
    func put<T: Encodable>(
        onSuccess: @escaping () -> Void,
        onFailed: @escaping (String) -> Void,
        path: String,
        body: T? = nil
    ) {
        let urlString = Route.baseUrl + path

        guard let url = urlString.asUrl else {
            onFailed("Invalid URL")
            return
        }




        // Gönderilecek veriyi encode ediyoruz.
        guard let body = body else {
            onFailed("Body is nil.")
            return
        }

        AF.request(url,
            method: .put,
            parameters: body,
            encoder: JSONParameterEncoder.default, headers: AppConstants.headers).response { response in
            response.response?.statusCode == 200 ? onSuccess() : onFailed("Failed")
        }
    }

    // MARK: - DELETE Request
    func delete(
        onSuccess: @escaping () -> Void,
        onFailed: @escaping (String) -> Void,
        path: String
    ) {
        let urlString = Route.baseUrl + path

        guard let url = urlString.asUrl else {
            onFailed("Invalid URL")
            return
        }

        AF.request(url, method: .delete, headers: AppConstants.headers)
            .response { response in
            switch response.result {
            case .success:
                onSuccess()
            case .failure(let error):
                onFailed(error.localizedDescription)
            }
        }
    }
}


