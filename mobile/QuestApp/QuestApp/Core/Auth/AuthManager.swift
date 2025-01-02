class AuthManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUsername: String = "user"
    
    private let authService: IAuthService
    
    init(authService: IAuthService = AuthService()) {
        self.authService = authService
    }
    
    func checkToken() {
        guard let tokenData = KeychainHelper.shared.read(for: "authToken"),
              let token = String(data: tokenData, encoding: .utf8) else {
            logout()
            return
        }
        
        // Token'ın geçerliliğini kontrol et
        validateToken(token)
    }
    
    private func validateToken(_ token: String) {
        authService.validateToken { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isLoggedIn = true
                case .failure:
                    self?.logout()
                }
            }
        }
    }
    
    func setUsername(_ username: String) {
        currentUsername = username
    }
    
    func logout() {
        KeychainHelper.shared.delete(for: "authToken")
        isLoggedIn = false
        currentUsername = "user"
    }
    
    // NetworkManager'dan 401 hatası alındığında çağrılacak method
    func handleUnauthorized() {
        DispatchQueue.main.async { [weak self] in
            self?.logout()
        }
    }
} 