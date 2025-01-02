import Foundation

final class RegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isRegistered: Bool = false
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let authService: IAuthService
    private let authManager: AuthManager
    
    init(authService: IAuthService = AuthService(), authManager: AuthManager = AuthManager()) {
        self.authService = authService
        self.authManager = authManager
    }
    
    func register() {
        isLoading = true
        let model = AuthRequestModel(userName: username, password: password)
        
        authService.register(model: model) { [weak self] response in
            if let response = response {
                // Kayıt başarılı, şimdi login yapalım
                self?.login(username: self?.username ?? "", password: self?.password ?? "")
            } else {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = "Kayıt başarısız"
                }
            }
        } onFailed: { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.errorMessage = error
            }
        }
    }
    
    private func login(username: String, password: String) {
        let model = AuthRequestModel(userName: username, password: password)
        
        authService.login(model: model) { [weak self] response in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let token = response?.accessToken {
                    let cleanToken = token.replacingOccurrences(of: "Bearer ", with: "")
                    if let tokenData = cleanToken.data(using: .utf8) {
                        KeychainHelper.shared.save(tokenData, for: "authToken")
                        self?.isRegistered = true
                        self?.authManager.setUsername(username)
                    } else {
                        self?.errorMessage = "Token işlenirken hata oluştu"
                    }
                } else {
                    self?.errorMessage = "Giriş başarısız"
                }
            }
        } onFailed: { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.errorMessage = error
            }
        }
    }
} 
